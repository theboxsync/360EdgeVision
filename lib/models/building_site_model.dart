class BuildingSiteModel {
  final Project? project;
  final About? about;
  final AboutHeader? aboutHeader;
  final List<Gallery>? gallery;
  final List<Specification>? specifications;
  final List<Amenities>? amenities;
  final Categories? categories;

  BuildingSiteModel({this.project, this.about, this.aboutHeader, this.gallery, this.specifications, this.amenities, this.categories});

  factory BuildingSiteModel.fromJson(Map<String, dynamic> json) {
    return BuildingSiteModel(
      project: json['project'] != null ? Project.fromJson(json['project']) : null,
      about: json['about'] != null ? About.fromJson(json['about']) : null,
      aboutHeader: json['about_header'] != null ? AboutHeader.fromJson(json['about_header']) : null,
      gallery: (json['gallery'] as List<dynamic>?)?.map((e) => Gallery.fromJson(e)).toList(),
      specifications: (json['specifications'] as List<dynamic>?)?.map((e) => Specification.fromJson(e)).toList(),
      amenities: (json['amenities'] as List<dynamic>?)?.map((e) => Amenities.fromJson(e)).toList(),
      categories: json['categories'] != null ? Categories.fromJson(json['categories']) : null,
    );
  }
}

/// Project
class Project {
  final String? id;
  final String? name;
  final String? description;
  final String? sequenceId;
  final String? userId;

  Project({this.id, this.name, this.description, this.sequenceId, this.userId});

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(id: json['id'], name: json['name'], description: json['description'], sequenceId: json['sequence_id'], userId: json['user_id']);
  }
}

/// About
class About {
  final String? id;
  final String? logoWhite;
  final String? logoOriginal;
  final String? clientName;
  final String? projectYear;
  final String? projectType;
  final String? projectAddress;
  final String? brochure;
  final String? googleLink;
  final String? videoLink;
  final String? projectId;
  final String? userId;
  final String? logoWhiteUrl;
  final String? logoOriginalUrl;
  final String? brochureUrl;

  About({
    this.id,
    this.logoWhite,
    this.logoOriginal,
    this.clientName,
    this.projectYear,
    this.projectType,
    this.projectAddress,
    this.brochure,
    this.googleLink,
    this.videoLink,
    this.projectId,
    this.userId,
    this.logoWhiteUrl,
    this.logoOriginalUrl,
    this.brochureUrl,
  });

  factory About.fromJson(Map<String, dynamic> json) {
    return About(
      id: json['id'],
      logoWhite: json['logo_white'],
      logoOriginal: json['logo_original'],
      clientName: json['client_name'],
      projectYear: json['project_year'],
      projectType: json['project_type'],
      projectAddress: json['project_address'],
      brochure: json['brochure'],
      googleLink: json['google_link'],
      videoLink: json['video_link'],
      projectId: json['project_id'],
      userId: json['user_id'],
      logoWhiteUrl: json['logo_white_url'],
      logoOriginalUrl: json['logo_original_url'],
      brochureUrl: json['brochure_url'],
    );
  }
}

/// About Header
class AboutHeader {
  final String? id;
  final String? header;
  final String? projectId;
  final String? userId;
  final List<AboutHeaderDescription>? descriptions;

  AboutHeader({this.id, this.header, this.projectId, this.userId, this.descriptions});

  factory AboutHeader.fromJson(Map<String, dynamic> json) {
    return AboutHeader(
      id: json['id'],
      header: json['header'],
      projectId: json['project_id'],
      userId: json['user_id'],
      descriptions: (json['descriptions'] as List<dynamic>?)?.map((e) => AboutHeaderDescription.fromJson(e)).toList(),
    );
  }
}

class AboutHeaderDescription {
  final String? id;
  final String? paragraph;
  final String? aboutHeaderId;
  final String? projectId;
  final String? userId;

  AboutHeaderDescription({this.id, this.paragraph, this.aboutHeaderId, this.projectId, this.userId});

  factory AboutHeaderDescription.fromJson(Map<String, dynamic> json) {
    return AboutHeaderDescription(
      id: json['id'],
      paragraph: json['paragraph'],
      aboutHeaderId: json['about_heade_id'],
      projectId: json['project_id'],
      userId: json['user_id'],
    );
  }
}

/// Gallery
class Gallery {
  final String? id;
  final String? imageName;
  final String? sequence;
  final String? type;
  final String? projectId;
  final String? uploadedAt;
  final String? userId;
  final String? imageUrl;

  Gallery({this.id, this.imageName, this.sequence, this.type, this.projectId, this.uploadedAt, this.userId, this.imageUrl});

  factory Gallery.fromJson(Map<String, dynamic> json) {
    return Gallery(
      id: json['id'],
      imageName: json['image_name'],
      sequence: json['sequence'],
      type: json['type'],
      projectId: json['project_id'],
      uploadedAt: json['uploaded_at'],
      userId: json['user_id'],
      imageUrl: json['image_url'],
    );
  }
}

/// Specification
class Specification {
  final String? id;
  final String? header;
  final String? projectId;
  final String? userId;
  final List<SpecificationDescription>? descriptions;

  Specification({this.id, this.header, this.projectId, this.userId, this.descriptions});

  factory Specification.fromJson(Map<String, dynamic> json) {
    return Specification(
      id: json['id'],
      header: json['header'],
      projectId: json['project_id'],
      userId: json['user_id'],
      descriptions: (json['descriptions'] as List<dynamic>?)?.map((e) => SpecificationDescription.fromJson(e)).toList(),
    );
  }
}

class SpecificationDescription {
  final String? id;
  final String? title;
  final String? description;
  final String? specificationHeaderId;
  final String? projectId;
  final String? userId;

  SpecificationDescription({this.id, this.title, this.description, this.specificationHeaderId, this.projectId, this.userId});

  factory SpecificationDescription.fromJson(Map<String, dynamic> json) {
    return SpecificationDescription(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      specificationHeaderId: json['specification_header_id'],
      projectId: json['project_id'],
      userId: json['user_id'],
    );
  }
}

class Amenities {
  final String? icon;
  final String? name;
  final String? projectId;

  Amenities({this.icon, this.name, this.projectId});

  factory Amenities.fromJson(Map<String, dynamic> json) {
    return Amenities(icon: json['icon'], name: json['name'], projectId: json['project_id']);
  }
}

/// Categories
class Categories {
  final bool? hasExterior;
  final bool? hasInterior;
  final bool? hasAmenities;

  Categories({this.hasExterior, this.hasInterior, this.hasAmenities});

  factory Categories.fromJson(Map<String, dynamic> json) {
    return Categories(hasExterior: json['hasExterior'], hasInterior: json['hasInterior'], hasAmenities: json['hasAmenities']);
  }
}
