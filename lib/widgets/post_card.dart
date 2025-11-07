import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/index.dart';
import '../services/index.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final VoidCallback onLike;

  const PostCard({
    Key? key,
    required this.post,
    required this.onLike,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final DownloadService _downloadService = DownloadService();
  bool _isDownloading = false;

  void _showDownloadOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Download Image'),
              onTap: () {
                Navigator.pop(context);
                _downloadMedia(0, 'image');
              },
            ),
            if (widget.post.mediaTypes.contains('video'))
              ListTile(
                leading: const Icon(Icons.download),
                title: const Text('Download Video'),
                onTap: () {
                  Navigator.pop(context);
                  _downloadMedia(0, 'video');
                },
              ),
            ListTile(
              leading: const Icon(Icons.report),
              title: const Text('Report'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.link),
              title: const Text('Copy Link'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadMedia(int index, String type) async {
    setState(() {
      _isDownloading = true;
    });

    try {
      String? path;
      if (type == 'image') {
        path = await _downloadService.downloadImage(
          widget.post.mediaUrls[index],
          widget.post.author.username,
          postId: widget.post.id,
        );
      } else {
        path = await _downloadService.downloadVideo(
          widget.post.mediaUrls[index],
          widget.post.author.username,
          postId: widget.post.id,
        );
      }

      if (mounted) {
        if (path != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Downloaded to: $path'),
              duration: const Duration(seconds: 3),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Download failed'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Profile image
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                child: widget.post.author.profileImageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CachedNetworkImage(
                          imageUrl: widget.post.author.profileImageUrl!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(Icons.person, size: 20),
              ),
              const SizedBox(width: 12),

              // Username and location
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.post.author.username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    if (widget.post.location != null)
                      Text(
                        widget.post.location!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                  ],
                ),
              ),

              // Menu button
              PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: const Text('Download'),
                    onTap: _showDownloadOptions,
                  ),
                  PopupMenuItem(
                    child: const Text('Report'),
                    onTap: () {},
                  ),
                  PopupMenuItem(
                    child: const Text('Copy Link'),
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),

        // Image/Video
        if (widget.post.mediaUrls.isNotEmpty)
          Container(
            width: double.infinity,
            height: 400,
            color: Colors.grey[300],
            child: CachedNetworkImage(
              imageUrl: widget.post.mediaUrls[0],
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) =>
                  const Icon(Icons.image_not_supported),
            ),
          ),

        // Actions
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Like, comment, share
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      widget.post.isLiked
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: widget.post.isLiked ? Colors.red : Colors.black,
                    ),
                    onPressed: widget.onLike,
                  ),
                  IconButton(
                    icon: const Icon(Icons.comment_outlined),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {},
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.bookmark_outline),
                    onPressed: () {},
                  ),
                ],
              ),

              // Likes count
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  '${widget.post.likesCount} likes',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),

              // Caption
              if (widget.post.caption != null && widget.post.caption!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: widget.post.author.username,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: ' ${widget.post.caption}',
                          style: const TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),

              // Comments count
              if (widget.post.commentsCount > 0)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'View all ${widget.post.commentsCount} comments',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
            ],
          ),
        ),

        const Divider(),
      ],
    );
  }
}
