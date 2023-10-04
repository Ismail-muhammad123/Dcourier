import 'package:cloud_firestore/cloud_firestore.dart';

class JobRequest {
  late String jobID;
  late String creatorID;
  late String applocantID;
  late Timestamp appliedAt;
  bool accepted;
  Timestamp? acceptedAt;

  JobRequest({
    required this.jobID,
    required this.creatorID,
    required this.applocantID,
    required this.appliedAt,
    this.accepted = false,
    this.acceptedAt,
  });

  factory JobRequest.fromMap(Map<String, dynamic> data) {
    return JobRequest(
      jobID: data['job_id'],
      creatorID: data['creator_id'],
      applocantID: data['applicant_id'],
      appliedAt: data['applied_at'],
      accepted: data['accepted'] ?? false,
      acceptedAt: data['accepted_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "job_id": jobID,
      "creator_id": creatorID,
      "applicant_id": applocantID,
      "applied_at": appliedAt,
      "accepted": accepted,
      "accepted_at": acceptedAt,
    };
  }
}
