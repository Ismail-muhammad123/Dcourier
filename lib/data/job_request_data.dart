import 'package:cloud_firestore/cloud_firestore.dart';

class JobRequest {
  String? id;
  late String jobID;
  late String creatorID;
  late String courierId;
  late Timestamp? appliedAt;
  String? status;
  Timestamp? acceptedAt;
  bool accepted;

  JobRequest({
    required this.jobID,
    required this.creatorID,
    required this.courierId,
    required this.appliedAt,
    required this.status,
    this.accepted = false,
    this.acceptedAt,
    this.id,
  });

  factory JobRequest.fromMap(Map<String, dynamic> data) {
    return JobRequest(
      jobID: data['job_id'],
      creatorID: data['creator_id'],
      courierId: data['courier_id'],
      appliedAt: data['applied_at'],
      status: data['status'],
      accepted: data['accepted'] ?? false,
      acceptedAt: data['accepted_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "job_id": jobID,
      "creator_id": creatorID,
      "courier_id": courierId,
      "status": status,
      "accepted": accepted,
      "accepted_at": acceptedAt,
    };
  }
}
