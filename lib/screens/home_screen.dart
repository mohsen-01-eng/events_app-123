import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

Widget buildPosts() {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('posts').orderBy('timestamp', descending: true).snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return const Center(child: CircularProgressIndicator());
      }
      return ListView(
        children: snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
          return ListTile(
            title: Text(data['userName']),
            subtitle: Text(data['content']),
            // إضافة المزيد من التفاصيل حسب نوع المنشور (نصي، صورة، موقع)
          );
        }).toList(),
      );
    },
  );
}


Future<void> addMediaPost(String userId, String userName, String content, String mediaUrl) async {
  await FirebaseFirestore.instance.collection('posts').add({
    'userId': userId,
    'userName': userName,
    'content': content,
    'mediaUrl': mediaUrl,
    'type': 'media',
    'timestamp': FieldValue.serverTimestamp(),
  });
}

// تحميل صورة/فيديو إلى Firebase Storage
Future<String> uploadMedia(File file) async {
  Reference storageReference = FirebaseStorage.instance.ref().child('posts/${DateTime.now().millisecondsSinceEpoch}');
  UploadTask uploadTask = storageReference.putFile(file);
  TaskSnapshot taskSnapshot = await uploadTask;
  return await taskSnapshot.ref.getDownloadURL();
}


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الصفحة الرئيسية'),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => _showLanguageOptions(context),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterOptions(context),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddPostOptions(context),
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // عرض الإشعارات
              _showNotifications(context);
            },
          ),
        ],
      ),
      body: const Center(child: Text('محتوى الصفحة الرئيسية')),
    );
  }

  // قائمة تغيير اللغة
  void _showLanguageOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('العربية'),
              onTap: () {
                // كود تغيير اللغة إلى العربية
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('English'),
              onTap: () {
                // كود تغيير اللغة إلى الإنجليزية
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  // خيارات الفلتر
  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
              title: const Text('المناسبة العائلية'),
              value: false, // حالة الفلتر الأول
              onChanged: (value) {
                // تحديث الفلتر
              },
            ),
            CheckboxListTile(
              title: const Text('الليل'),
              value: false,
              onChanged: (value) {
                // تحديث الفلتر
              },
            ),
            // إضافة باقي خيارات الفلتر بنفس الشكل...
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('رجوع'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // تطبيق الفلاتر المحددة
                    Navigator.pop(context);
                  },
                  child: const Text('موافق'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // خيارات إضافة منشور جديد
  void _showAddPostOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.text_fields),
              title: const Text('إضافة نص'),
              onTap: () {
                // عرض شاشة لإضافة نص فقط
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('إضافة صورة/فيديو'),
              onTap: () {
                // عرض شاشة لإضافة صورة أو فيديو
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('إضافة موقع'),
              onTap: () {
                // عرض شاشة لإضافة موقع
              },
            ),
          ],
        );
      },
    );
  }

  // عرض الإشعارات
  void _showNotifications(BuildContext context) {
    // هنا يمكنك استخدام Firebase Cloud Messaging للحصول على الإشعارات
    // وعرضها عند استلامها.
  }
}
void addTextPost(String userId, String userName, String content) {
  FirebaseFirestore.instance.collection('posts').add({
    'userId': userId,
    'userName': userName,
    'content': content,
    'type': 'text',
    'timestamp': FieldValue.serverTimestamp(),
  });
}

void addLocationPost(String userId, String userName, String content, GeoPoint location) {
  FirebaseFirestore.instance.collection('posts').add({
    'userId': userId,
    'userName': userName,
    'content': content,
    'location': location,
    'type': 'location',
    'timestamp': FieldValue.serverTimestamp(),
  });
}

void likePost(String postId, String userId) {
  FirebaseFirestore.instance.collection('posts').doc(postId).update({
    'likes': FieldValue.arrayUnion([userId])
  });
}
void commentOnPost(String postId, String userId, String userName, String comment) {
  FirebaseFirestore.instance.collection('posts').doc(postId).collection('comments').add({
    'userId': userId,
    'userName': userName,
    'comment': comment,
    'timestamp': FieldValue.serverTimestamp(),
  });
}
