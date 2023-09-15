/*
 * Copyright (c) 2020 .
 */

import 'dart:core';

import 'package:flutter/material.dart';

import '../../common/uuid.dart';
import 'address_model.dart';
import 'availability_hour_model.dart';
import 'media_model.dart';
import 'parents/model.dart';
import 'review_model.dart';
import 'salon_level_model.dart';
import 'tax_model.dart';
import 'user_model.dart';

class Salon extends Model {

  String? id;
  String? name;
  String? description;
  List<Media>? images;
  String? phoneNumber;
  String? mobileNumber;
  SalonLevel? salonLevel;
  List<AvailabilityHour>? availabilityHours;
  double? availabilityRange;
  double? distance;
  bool? closed;
  bool? featured;
  Address? address;
  List<Tax>? taxes;

  List<User>? employees;
  double? rate;
  List<Review>? reviews;
  int? totalReviews;
  bool? verified;


  Salon(
      {this.id,
      this.name,
      this.description,
      this.images,
      this.phoneNumber,
      this.mobileNumber,
      this.salonLevel,
      this.availabilityHours,
      this.availabilityRange,
      this.distance,
      this.closed,
      this.featured,
      this.address,
      this.employees,
      this.rate,
      this.reviews,
      this.totalReviews,
      this.verified});

  Salon.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    name = transStringFromJson(json, 'name');
    description = transStringFromJson(json, 'description', defaultValue: "");
    images = mediaListFromJson(json, 'images');
    phoneNumber = stringFromJson(json, 'phone_number');
    mobileNumber = stringFromJson(json, 'mobile_number');
    salonLevel = objectFromJson(json, 'salon_level', (v) => SalonLevel.fromJson(v));
    availabilityHours = listFromJson(json, 'availability_hours', (v) => AvailabilityHour.fromJson(v));
    availabilityRange = doubleFromJson(json, 'availability_range');
    distance = doubleFromJson(json, 'distance');
    closed = boolFromJson(json, 'closed');
    featured = boolFromJson(json, 'featured');
    address = objectFromJson(json, 'address', (v) => Address.fromJson(v));
    taxes = listFromJson(json, 'taxes', (v) => Tax.fromJson(v));
    employees = listFromJson(json, 'users', (v) => User.fromJson(v));
    rate = doubleFromJson(json, 'rate');
    reviews = listFromJson(json, 'salon_reviews', (v) => Review.fromJson(v));
    totalReviews = reviews!.isEmpty ? intFromJson(json, 'total_reviews') : reviews?.length;
    verified = boolFromJson(json, 'verified');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['closed'] = this.closed;
    data['phone_number'] = this.phoneNumber;
    data['mobile_number'] = this.mobileNumber;
    data['rate'] = this.rate;
    data['total_reviews'] = this.totalReviews;
    data['verified'] = this.verified;
    data['distance'] = this.distance;
    //data['availability_range'] = this.availabilityRange;
    data['availability_range'] = this.availabilityRange != null && this.availabilityRange != 0
        ? this.availabilityRange
        : 10000;
    data['address_id'] = this.address!.id;
    if (this.images != null) {
      // data['image'] = this.images.where((element) => Uuid.isUuid(element.id)).map((v) => v.id).toList();
      data['image'] = this.images!.where((element) => Uuid.isUuid(element.id)).map((v) => v.id).toList();
    }
    return data;
  }

  String get firstImageUrl => this.images?.first?.url ?? '';

  String get firstImageThumb => this.images?.first?.thumb ?? '';

  String get firstImageIcon => this.images?.first?.icon ?? '';

  @override
  bool get hasData {
    return id != null && name != null;
  }

 void SorteAvailabilityHour()
  {
    this.availabilityHours?.map((e) => {
       if(e.day?.toLowerCase() == "monday")
         {
           e.sortOrder =1
         }
      else if(e.day?.toLowerCase() == "tuesday")
        {
          e.sortOrder =2
        }
       else if(e.day?.toLowerCase() == "wednesday")
           {
             e.sortOrder =3
           }
         else if(e.day?.toLowerCase() == "thursday")
             {
               e.sortOrder =4
             }
           else if(e.day?.toLowerCase() == "friday")
               {
                 e.sortOrder =5
               }
             else if(e.day?.toLowerCase() == "saturday")
                 {
                   e.sortOrder =6
                 }

               else if(e.day?.toLowerCase() == "sunday")
                   {
                     e.sortOrder =7
                   }


    });
    this.availabilityHours?.sort((a, b) => a.sortOrder!.compareTo(b.sortOrder!));

  }

  Map<String, List<String>> groupedAvailabilityHours() {
    Map<String, List<String>> result = {};
    this.availabilityHours?.forEach((element) {
      if (result.containsKey(element.day)) {
        result[element.day]?.add(element.startAt! + ' - ' + element.endAt!);
      } else {
        result[element.day!] = [element.startAt! + ' - ' + element.endAt!];
      }
    });
    return result;
  }

  List<String> getAvailabilityHoursData(String day) {
    List<String> result = [];
    this.availabilityHours?.forEach((element) {
      if (element.day == day) {
        result.add(element.data!);
      }
    });
    return result;
  }

  @override
  bool operator ==(Object? other) =>
      identical(this, other) ||
      super == other &&
          other is Salon &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          images == other.images &&
          phoneNumber == other.phoneNumber &&
          mobileNumber == other.mobileNumber &&
          salonLevel == other.salonLevel &&
          availabilityRange == other.availabilityRange &&
          distance == other.distance &&
          closed == other.closed &&
          featured == other.featured &&
          address == other.address &&
          rate == other.rate &&
          reviews == other.reviews &&
          totalReviews == other.totalReviews &&
          verified == other.verified;

  @override
  int get hashCode =>
      super.hashCode ^
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      images.hashCode ^
      phoneNumber.hashCode ^
      mobileNumber.hashCode ^
      salonLevel.hashCode ^
      availabilityRange.hashCode ^
      distance.hashCode ^
      closed.hashCode ^
      featured.hashCode ^
      address.hashCode ^
      rate.hashCode ^
      reviews.hashCode ^
      totalReviews.hashCode ^
      verified.hashCode;
}
