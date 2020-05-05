
import 'package:flutterapp/main.dart';

import 'package:http/http.dart' as http;


class Comment {
	final String id;
	final String text;

  Comment(this.id, this.text);

//  Comment.fromJson(Map<String, dynamic> map):
//			id =
}

class Post {

  final List<String> likes_users;
  final List<String> shared_users;
  final List<String> hashtags;
  final String id;
  final String text;
  final String userId;
  int likes;
  int shares;
  final List<Object> comments;
  final String createdAt;
  final String updatedAt;
  final int __v;

	Post.fromJsonMap(Map<String, dynamic> map):
		likes_users = List<String>.from(map["likes_users"]),
		shared_users = List<String>.from(map["shared_users"]),
		hashtags = List<String>.from(map["hashtags"]),
		id = map["_id"],
		text = map["text"],
		userId = map["userId"],
		likes = map["likes"],
		shares = map["shares"],
		comments = map["comments"],
		createdAt = map["createdAt"],
		updatedAt = map["updatedAt"],
		__v = map["__v"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['likes_users'] = likes_users;
		data['shared_users'] = shared_users;
		data['hashtags'] = hashtags;
		data['_id'] = id;
		data['text'] = text;
		data['userId'] = userId;
		data['likes'] = likes;
		data['shares'] = shares;
		data['comments'] = comments;
		data['createdAt'] = createdAt;
		data['updatedAt'] = updatedAt;
		data['__v'] = __v;
		return data;
	}

	static Future<void> likePost(String postId) async {
		print(postId);
		final token = await storage.read(key: 'jwt');
		final res = await http.post(
				"$SERVER_IP/post/like/id=$postId",
				headers: {
					"token": token
				}
		);
		print(postId);
		print(res.body);
	}

	static Future<void> unlikePost(String postId) async {
		print(postId);
		final token = await storage.read(key: 'jwt');
		final res = await http.delete(
				"$SERVER_IP/post/unlike/id=$postId",
				headers: {
					"token": token
				}
		);
		print(postId);
		print(res.body);
	}

	static Future<String> getPost(String postId) async {
		final token = await storage.read(key: 'jwt');
		final res = await http.get(
				"$SERVER_IP/post/id=$postId",
				headers: {
					"token": token
				}
		);
		if (res.statusCode == 200) return res.body;
		return null;
	}
}
