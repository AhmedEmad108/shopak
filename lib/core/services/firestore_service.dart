import 'package:shopak/core/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// خدمة قاعدة البيانات Firestore
/// تقوم بتنفيذ العمليات الأساسية على قاعدة البيانات
class FirestoreService implements DatabaseService {
  // مثيل من Firestore
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// إضافة بيانات جديدة
  /// [path] مسار المجموعة
  /// [data] البيانات المراد إضافتها
  /// [documentId] معرف المستند (اختياري)
  /// [generatedId] إذا كان true سيتم توليد معرف جديد
  @override
  Future<void> addData({
    required String path,
    required Map<String, dynamic> data,
    String? documentId,
    bool? generatedId,
  }) async {
    if (generatedId == true) {
      DocumentReference docRef = firestore.collection(path).doc();
      String generatedId = docRef.id;
      data['id'] = generatedId;
      await docRef.set(data);
    } else if (documentId != null) {
      await firestore.collection(path).doc(documentId).set(data);
    } else {
      await firestore.collection(path).add(data);
    }
  }

  /// جلب البيانات
  /// [path] مسار المجموعة
  /// [documentId] معرف المستند (اختياري)
  /// [query] معايير البحث والفلترة (اختياري)
  @override
  Future<dynamic> getData({
    required String path,
    String? documentId,
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
  }) async {
    if (documentId != null) {
      var data = await firestore.collection(path).doc(documentId).get();
      return data.data();
    } else {
      // إنشاء query أساسي
      Query<Map<String, dynamic>> queryRef = firestore.collection(path);

      // إضافة الفلاتر إذا وجدت
      if (query != null) {
        // فلترة حسب الحالة
        if (query['isActive'] != null) {
          queryRef = queryRef.where('isActive', isEqualTo: query['isActive']);
        }

        // الترتيب إذا كان موجود
        if (query['orderBy'] != null) {
          queryRef = queryRef.orderBy(
            query['orderBy'],
            descending: query['descending'] ?? false,
          );
        }

        // تحديد العدد إذا كان موجود
        if (query['limit'] != null) {
          queryRef = queryRef.limit(query['limit']);
        }
      }

      // تنفيذ الاستعلام
      var snapshot = await queryRef.get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    }
  }

  /// التحقق من وجود البيانات
  /// [path] مسار المجموعة
  /// [documentId] معرف المستند
  @override
  Future<bool> checkIfDataExists({
    required String path,
    required String documentId,
  }) async {
    var data = await firestore.collection(path).doc(documentId).get();
    return data.exists;
  }

  /// حذف البيانات
  /// [path] مسار المجموعة
  /// [documentId] معرف المستند
  @override
  Future<void> deleteData({
    required String path,
    required String documentId,
  }) async {
    await firestore.collection(path).doc(documentId).delete();
  }

  /// تحديث البيانات
  /// [path] مسار المجموعة
  /// [data] البيانات المحدثة
  /// [documentId] معرف المستند
  @override
  Future<void> updateData({
    required String path,
    required Map<String, dynamic> data,
    String? documentId,
  }) async {
    await firestore.collection(path).doc(documentId).update(data);
  }

  /// الحصول على stream للبيانات للتحديثات المباشرة
  /// [path] مسار المجموعة
  /// [query] معايير البحث والفلترة (اختياري)
  Stream<List<Map<String, dynamic>>> getDataStream({
    required String path,
    Map<String, dynamic>? query,
  }) {
    Query<Map<String, dynamic>> ref = firestore.collection(path);

    if (query != null) {
      if (query['isActive'] != null) {
        ref = ref.where('isActive', isEqualTo: query['isActive']);
      }
      if (query['orderBy'] != null) {
        ref = ref.orderBy(
          query['orderBy'],
          descending: query['descending'] ?? false,
        );
      }
    }

    return ref.snapshots().map(
      (snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),
    );
  }

  /// البحث في البيانات
  /// [path] مسار المجموعة
  /// [searchField] الحقل المراد البحث فيه
  /// [query] نص البحث
  /// [isActive] فلتر الحالة (اختياري)
  Future<List<Map<String, dynamic>>> searchData({
    required String path,
    required String searchField,
    required String query,
    bool? isActive,
  }) async {
    Query<Map<String, dynamic>> ref = firestore.collection(path);

    // إضافة فلتر الحالة إذا كان مطلوباً
    if (isActive != null) {
      ref = ref.where('isActive', isEqualTo: isActive);
    }

    var snapshot = await ref.get();
    var allData =
        snapshot.docs.map((doc) {
          var data = doc.data();
          data['id'] = doc.id; // إضافة ID للبيانات
          return data;
        }).toList();

    // البحث في الحقول المطلوبة
    return allData.where((doc) {
      String fieldValue = doc[searchField]?.toString().toLowerCase() ?? '';
      return fieldValue.contains(query.toLowerCase());
    }).toList();
  }
}

// import 'package:shopak/core/services/database_service.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class FirestoreService implements DatabaseService {
//   FirebaseFirestore firestore = FirebaseFirestore.instance;
//   @override
//   Future<void> addData({
//     required String path,
//     required Map<String, dynamic> data,
//     String? documentId,
//     bool? generatedId,
//   }) async {
//     if (generatedId == true) {
//       DocumentReference docRef = firestore.collection(path).doc();
//       String generatedId = docRef.id;
//       data['id'] = generatedId;
//       await docRef.set(data);
//     } else if (documentId != null) {
//       await firestore.collection(path).doc(documentId).set(data);
//     } else {
//       await firestore.collection(path).add(data);
//     }
//   }

//   @override
//   Future<dynamic> getData({
//     required String path,
//     String? documentId,
//     Map<String, dynamic>? data,
//     Map<String, dynamic>? query,
//   }) async {
//     if (documentId != null) {
//       var data = await firestore.collection(path).doc(documentId).get();
//       return data.data();
//     } else {
//       // إنشاء query أساسي
//       Query<Map<String, dynamic>> queryRef = firestore.collection(path);

//       // إضافة الفلاتر إذا وجدت
//       if (query != null) {
//         // فلترة حسب الحالة
//         if (query['status'] != null) {
//           queryRef = queryRef.where('status', isEqualTo: query['status']);
//         }

//         // الترتيب إذا كان موجود
//         if (query['orderBy'] != null) {
//           queryRef = queryRef.orderBy(
//             query['orderBy'],
//             descending: query['descending'] ?? false,
//           );
//         }

//         // تحديد العدد إذا كان موجود
//         if (query['limit'] != null) {
//           queryRef = queryRef.limit(query['limit']);
//         }
//       }

//       // تنفيذ الاستعلام
//       var snapshot = await queryRef.get();
//       return snapshot.docs.map((doc) => doc.data()).toList();
//     }
//   }

//   @override
//   Future<bool> checkIfDataExists({
//     required String path,
//     required String documentId,
//   }) async {
//     var data = await firestore.collection(path).doc(documentId).get();
//     return data.exists;
//   }

//   @override
//   Future<void> deleteData({
//     required String path,
//     required String documentId,
//   }) async {
//     await firestore.collection(path).doc(documentId).delete();
//   }

//   @override
//   Future<void> updateData({
//     required String path,
//     required Map<String, dynamic> data,
//     String? documentId,
//   }) async {
//     await firestore.collection(path).doc(documentId).update(data);
//   }

//   // إضافة دالة جديدة تعيد Stream
//   Stream<List<Map<String, dynamic>>> getDataStream({
//     required String path,
//     Map<String, dynamic>? query,
//   }) {
//     Query<Map<String, dynamic>> ref = firestore.collection(path);

//     if (query != null) {
//       if (query['isActive'] != null) {
//         ref = ref.where('isActive', isEqualTo: query['isActive']);
//       }
//       if (query['orderBy'] != null) {
//         ref = ref.orderBy(
//           query['orderBy'],
//           descending: query['descending'] ?? false,
//         );
//       }
//     }

//     return ref.snapshots().map(
//       (snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),
//     );
//   }

//   // إضافة دالة جديدة للبحث
//   Future<List<Map<String, dynamic>>> searchData({
//     required String path,
//     required String searchField,
//     required String query,
//     bool? status,
//   }) async {
//     Query<Map<String, dynamic>> ref = firestore.collection(path);

//     // إضافة فلتر الحالة إذا كان مطلوباً
//     if (status != null) {
//       ref = ref.where('status', isEqualTo: status);
//     }

//     var snapshot = await ref.get();
//     var allData =
//         snapshot.docs.map((doc) {
//           var data = doc.data();
//           data['id'] = doc.id; // إضافة ID للبيانات
//           return data;
//         }).toList();

//     // البحث في الحقول المطلوبة
//     return allData.where((doc) {
//       String fieldValue = doc[searchField]?.toString().toLowerCase() ?? '';
//       return fieldValue.contains(query.toLowerCase());
//     }).toList();
//   }
// }
