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