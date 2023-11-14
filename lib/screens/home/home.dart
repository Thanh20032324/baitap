import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:du_an_fashion/consts.dart';

class ClothingItem {
  String? id;
  String name;
  String description;
  double price;
  String imageUrl;
  int times;

  ClothingItem({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.times,
  });
}


class Home extends StatefulWidget {

  final bool isAdmin;

  Home({required this.isAdmin});

  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {
  List<ClothingItem> clothingItem = [];
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection('clothingItems').snapshots().listen((snapshot) {
      setState(() {
        clothingItem = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return ClothingItem(
              id: doc.id,
              name: data['name'] ?? '',
              description: data['description'] ?? '',
              price: (data['price'] ?? 0.0).toDouble(),
              imageUrl: data['imageUrl'] ?? '',
              times: data['times'] ?? 0,
          );
        }).toList();
        clothingItem.sort((a, b) => a.times.compareTo(b.times));
      });
    });
  }
  Future<void> _upItem(ClothingItem item) async{
    try {
      await FirebaseFirestore.instance.collection('clothingItems').add({
        'name': item.name,
        'description': item.description,
        'price': item.price,
        'imageUrl': item.imageUrl,
        'times': item.times,
      });
      print('Đã thêm thành công dữ liệu');
    }catch(e){
      print('Lỗi dữ liệu tải lên !! $e');
    }
  }
  //bắn dữ liệu lên firebase
  Future<void> _uploadImage(ClothingItem item) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      PlatformFile file = result.files.single;
      try {
        String imageName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference reference =
        FirebaseStorage.instance.ref().child('images/$imageName.jpg');
        await reference.putFile(File(file.path!));
        String imageUrl = await reference.getDownloadURL();
        item.imageUrl = imageUrl;
        print("Image uploaded: $imageUrl");
        int currentTime = DateTime.now().microsecondsSinceEpoch;
        item.times = currentTime;
        // Lưu dữ liệu vào Firestore
        print('Data saved to Firestore');
      } catch (e) {
        print('Lỗi tải lên hình ảnh hoặc lưu dữ liệu vào Firestore: $e');
      }
    }
  }
// hàm xóa
  Future<void> _deleteItem(String? itemId) async {
    if (itemId != null) {
      try {
        await FirebaseFirestore.instance.collection('clothingItems').doc(itemId).delete();
        print('Item deleted from Firestore');
      } catch (e) {
        print('Error deleting item: $e');
      }
    }
  }
  Future<void> _uploadItem (ClothingItem item) async{
    await FirebaseFirestore.instance.collection('clothingItems').doc(item.id).update({
      'name': item.name,
      'description': item.description,
      'price': item.price,
      'imageUrl': item.imageUrl,
    });
    print('Đã cập nhật dữ liệu vào Firestore');
  }
  Future<void> _showUpdateDialog (ClothingItem item) async{
    TextEditingController nameController = TextEditingController(text: item.name);
    TextEditingController descriptionController = TextEditingController(text: item.description);
    TextEditingController priceController = TextEditingController(text: item.price.toString());

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Product'),
          content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Product Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price'),
              ),
            ],
          ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                item.name = nameController.text;
                item.description = descriptionController.text;
                item.price = double.tryParse(priceController.text) ?? 0.0;
                _uploadItem(item);
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        leading: Icon(Icons.home),
        backgroundColor: g2,
      ),
      floatingActionButton: widget.isAdmin
          ? FloatingActionButton(
        onPressed: () {
          ClothingItem newItem = ClothingItem(
            name: '',
            description: '',
            price: 0.0,
            imageUrl: '',
            times: 0,
          );

          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Thêm sản phẩm'),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        onChanged: (value) {
                          newItem.name = value ?? '';
                        },
                        decoration: InputDecoration(labelText: 'Tên sản phẩm'),
                      ),
                      TextField(
                        onChanged: (value) {
                          newItem.description = value ?? '';
                        },
                        decoration: InputDecoration(labelText: 'Mô tả'),
                      ),
                      TextField(
                        onChanged: (value) {
                          newItem.price = double.tryParse(value) ?? 0.0;
                        },
                        decoration: InputDecoration(labelText: 'Giá'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _uploadImage(newItem);
                        },
                        child: Text('Chọn ảnh'),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Hủy'),
                  ),
                  TextButton(
                    onPressed: () {
                      _upItem(newItem);
                      Navigator.of(context).pop();
                    },
                    child: Text('Thêm'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      )
          : null,
      body: GridView.extent(

          maxCrossAxisExtent: 200,
        crossAxisSpacing: 10, // khoảng cách các ô
        mainAxisSpacing: 10,
        children: clothingItem.map((item) {
          return Card(
            child: Column(
              children: [
                Expanded(
                  child: Image.network(
                    item.imageUrl,
                    height: 140,
                    width: 140,
                  ),
                ),
                Text(item.name),
                Text(item.description),
                Text('\$${item.price.toStringAsFixed(3)}'),
                if (widget.isAdmin)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Nút xóa
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteItem(item.id);
                        },
                      ),
                      // Nút cập nhật
                      IconButton(
                        icon: Icon(Icons.update),
                        onPressed: () {
                          _showUpdateDialog(item);
                        }
                      ),
                    ],
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
