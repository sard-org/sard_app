import 'package:equatable/equatable.dart';

/// This class defines the variables used in the [add_date_of_birth_light_version_dialog],
/// and is typically used to hold data that is passed between different parts of the application.
class AddDateOfBirthLightVersionModel extends Equatable {
  // هنا يمكن إضافة المتغيرات الخاصة بك
  final String? someData;  // مثال لمتغير داخل الكلاس

  // Constructor
  AddDateOfBirthLightVersionModel({this.someData});

  // CopyWith method
  AddDateOfBirthLightVersionModel copyWith({String? someData}) {
    return AddDateOfBirthLightVersionModel(
      someData: someData ?? this.someData, // إذا تم تمرير قيمة جديدة يتم تغييرها، وإلا يتم الاحتفاظ بالقيمة القديمة
    );
  }

  @override
  List<Object?> get props => [someData ?? ''];  // إضافة المتغيرات التي تريد أن تتم المقارنة بناءً عليها
}
