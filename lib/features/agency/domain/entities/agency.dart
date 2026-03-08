/// ---------------------------------------------------------------------------
/// Agency
/// ---------------------------------------------------------------------------
/// A Domain Entity representing a travel service provider.
/// 
/// This class serves as the blueprint for agency data used throughout the 
/// application, ensuring that business logic remains decoupled from 
/// external data formats (like API JSON).
/// ---------------------------------------------------------------------------
class Agency {
  final int id;
  final String name;
  final String? ownerName;
  final String? contact;
  final String? emailId;
  final String? licenceNo;
  final String? licenceURL;
  final String? addressInfo;

  Agency({
    required this.id,
    required this.name,
    this.ownerName,
    this.contact,
    this.emailId,
    this.licenceNo,
    this.licenceURL,
    this.addressInfo,
  });
}