import '../../common/enums/intervention_type.dart';

class SubmitAnswerResponse {
   String? id;
   InterventionType? status;

   SubmitAnswerResponse({this.id, this.status});

   factory SubmitAnswerResponse.fromJson(Map<String, dynamic> json) {
     return SubmitAnswerResponse(
       id: json['id'],
       status: InterventionTypeX.initFrom(json['survey_status']),
     );
   }
}