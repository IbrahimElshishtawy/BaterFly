// // ignore: unused_import
// import 'package:baterfly/app/data/models/product_model.dart';

// import '../../domain/entities/review.dart';
// import '../../domain/repositories/review_repository.dart';
// import '../models/review_model.dart';
// import '../datasources/remote/reviews_remote.dart';

// class ReviewRepositoryImpl implements ReviewRepository {
//   final ReviewsRemote _remote;
//   ReviewRepositoryImpl({ReviewsRemote? remote})
//     : _remote = remote ?? ReviewsRemote();

//   @override
//   Future<List<Review>> getReviews(int productId) async {
//     final data = await _remote.listApproved(productId);
//     // return data.map((r) => ReviewModel.fromMap(r)).toList();
//   }

//   // @override
//   // Future<Product?> getById(String idOrSlug) async {
//   //   final builder = _sb.from(_table).select().limit(1);
//   //   final res = int.tryParse(idOrSlug) != null
//   //       ? await builder.eq('id', int.parse(idOrSlug)).maybeSingle()
//   //       : await builder.eq('slug', idOrSlug).maybeSingle();

//   //   if (res == null) return null;
//   //   return ProductModel.fromMap(res as Map<String, dynamic>).toEntity();
//   // }

//   @override
//   Future<void> submitReview({
//     required int productId,
//     required String fullName,
//     required int rating,
//     required String comment,
//   }) {
//     return _remote.submit(
//       productId: productId,
//       fullName: fullName,
//       rating: rating,
//       comment: comment,
//     );
//   }
// }
