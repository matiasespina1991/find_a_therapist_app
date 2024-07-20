// List<Map<String, dynamic>> mockTherapistsList = [
//   {
//     "createdAt":
//         Timestamp.fromDate(DateTime.now().subtract(Duration(days: 200))),
//     "updatedAt":
//         Timestamp.fromDate(DateTime.now().subtract(Duration(days: 100))),
//     "aspects": {
//       "positive": ["anxiety", "depression"],
//       "negative": ["jungian", "eating-disorder"]
//     },
//     "subscription": {
//       "endsAt": Timestamp.fromDate(DateTime.now().add(Duration(days: 365))),
//       "plan": "gold",
//       "startedAt":
//           Timestamp.fromDate(DateTime.now().subtract(Duration(days: 100))),
//       "autoRenewal": true
//     },
//     "score": {"rating": 4.5, "amountRatings": 120},
//     "therapistInfo": {
//       "intro": "Experienced psychologist specializing in anxiety management.",
//       "location": {
//         "address": "China Bazaar Rd",
//         "city": "Raichur",
//         "country": "IN",
//         "geolocation": GeoPoint(16.20462, 77.35657),
//         "stateProvince": "Jammu and Kashmir",
//         "zip": "96790"
//       },
//       "firstName": "Nehrika",
//       "userInfoIsVerified": true,
//       "lastName": "Vernekar",
//       "specializations": ["psychologist", "counselor"],
//       "spokenLanguages": ["es", "en"],
//       "professionalCertificates": [
//         {
//           "yearObtained": 2010,
//           "photoUrl":
//               "https://www.4icu.org/i/programs-courses-degrees/graduate-diploma-of-psychology-500x356.png",
//           "title": "PhD in Psychology",
//           "type": "doctorate",
//           "institution": "University of Mumbai",
//           "verified": true
//         }
//       ],
//       "profilePictureUrl": {
//         "large": "https://randomuser.me/api/portraits/women/58.jpg",
//         "small": "https://randomuser.me/api/portraits/women/58.jpg",
//         "thumb": "https://randomuser.me/api/portraits/women/58.jpg"
//       }
//     }
//   },
//   {
//     "createdAt":
//         Timestamp.fromDate(DateTime.now().subtract(Duration(days: 300))),
//     "updatedAt":
//         Timestamp.fromDate(DateTime.now().subtract(Duration(days: 150))),
//     "aspects": {
//       "positive": ["anxiety", "depression"],
//       "negative": ["jungian", "eating-disorder"]
//     },
//     "subscription": {
//       "endsAt": Timestamp.fromDate(DateTime.now().add(Duration(days: 180))),
//       "plan": "silver",
//       "startedAt":
//           Timestamp.fromDate(DateTime.now().subtract(Duration(days: 150))),
//       "autoRenewal": false
//     },
//     "score": {"rating": 4.8, "amountRatings": 85},
//     "therapistInfo": {
//       "intro": "Therapist with a focus on trauma and recovery.",
//       "location": {
//         "address": "Kubanskoyi Ukrayini",
//         "city": "Verhivceve",
//         "country": "UA",
//         "geolocation": GeoPoint(48.47842, 35.24529),
//         "stateProvince": "Harkivska",
//         "zip": "37113"
//       },
//       "firstName": "Ondriy",
//       "userInfoIsVerified": false,
//       "lastName": "Sirchenko",
//       "specializations": ["psychologist", "counselor"],
//       "spokenLanguages": ["uk", "ru"],
//       "professionalCertificates": [
//         {
//           "yearObtained": 2008,
//           "photoUrl":
//               "https://www.iac-irtac.org/sites/default/files/styles/large/public/Picture1_1.png?itok=kwWlBzQk",
//           "title": "Masters in Counseling",
//           "type": "master",
//           "institution": "Kyiv National University",
//           "verified": true
//         }
//       ],
//       "profilePictureUrl": {
//         "large": "https://randomuser.me/api/portraits/men/61.jpg",
//         "small": "https://randomuser.me/api/portraits/men/61.jpg",
//         "thumb": "https://randomuser.me/api/portraits/men/61.jpg"
//       }
//     }
//   },
//   {
//     "createdAt":
//         Timestamp.fromDate(DateTime.now().subtract(Duration(days: 500))),
//     "updatedAt":
//         Timestamp.fromDate(DateTime.now().subtract(Duration(days: 250))),
//     "aspects": {
//       "positive": ["family therapy", "child psychology"],
//       "negative": ["addiction"]
//     },
//     "subscription": {
//       "endsAt": Timestamp.fromDate(DateTime.now().add(Duration(days: 365))),
//       "plan": "gold",
//       "startedAt":
//           Timestamp.fromDate(DateTime.now().subtract(Duration(days: 250))),
//       "autoRenewal": true
//     },
//     "score": {"rating": 4.7, "amountRatings": 150},
//     "therapistInfo": {
//       "intro": "Specializes in family therapy and child psychology.",
//       "location": {
//         "address": "Mcclellan Rd",
//         "city": "Wollongong",
//         "country": "AU",
//         "geolocation": GeoPoint(-34.424, 150.8934),
//         "stateProvince": "Western Australia",
//         "zip": "3982"
//       },
//       "firstName": "Leah",
//       "userInfoIsVerified": true,
//       "lastName": "Weaver",
//       "specializations": ["psychologist", "child psychologist"],
//       "spokenLanguages": ["en"],
//       "professionalCertificates": [
//         {
//           "yearObtained": 2012,
//           "photoUrl":
//               "https://www.4icu.org/i/programs-courses-degrees/graduate-diploma-of-psychology-500x356.png",
//           "title": "PhD in Child Psychology",
//           "type": "doctorate",
//           "institution": "University of Sydney",
//           "verified": true
//         }
//       ],
//       "profilePictureUrl": {
//         "large": "https://randomuser.me/api/portraits/women/93.jpg",
//         "small": "https://randomuser.me/api/portraits/women/93.jpg",
//         "thumb": "https://randomuser.me/api/portraits/women/93.jpg"
//       }
//     }
//   },
//   {
//     "createdAt":
//         Timestamp.fromDate(DateTime.now().subtract(Duration(days: 600))),
//     "updatedAt":
//         Timestamp.fromDate(DateTime.now().subtract(Duration(days: 300))),
//     "aspects": {
//       "positive": ["cognitive behavioral therapy", "depression"],
//       "negative": ["schizophrenia"]
//     },
//     "subscription": {
//       "endsAt": Timestamp.fromDate(DateTime.now().add(Duration(days: 730))),
//       "plan": "platinum",
//       "startedAt":
//           Timestamp.fromDate(DateTime.now().subtract(Duration(days: 300))),
//       "autoRenewal": true
//     },
//     "score": {"rating": 4.9, "amountRatings": 200},
//     "therapistInfo": {
//       "intro": "Veteran therapist with over 40 years of experience.",
//       "location": {
//         "address": "Washington Ave",
//         "city": "Gladstone",
//         "country": "AU",
//         "geolocation": GeoPoint(-23.8426, 151.2554),
//         "stateProvince": "Tasmania",
//         "zip": "5841"
//       },
//       "firstName": "Lucas",
//       "userInfoIsVerified": true,
//       "lastName": "Byrd",
//       "specializations": ["psychologist", "cognitive therapist"],
//       "spokenLanguages": ["en"],
//       "professionalCertificates": [
//         {
//           "yearObtained": 1975,
//           "photoUrl":
//               "https://www.4icu.org/i/programs-courses-degrees/graduate-diploma-of-psychology-500x356.png",
//           "title": "PhD in Clinical Psychology",
//           "type": "doctorate",
//           "institution": "University of Melbourne",
//           "verified": true
//         }
//       ],
//       "profilePictureUrl": {
//         "large": "https://randomuser.me/api/portraits/men/71.jpg",
//         "small": "https://randomuser.me/api/portraits/men/71.jpg",
//         "thumb": "https://randomuser.me/api/portraits/men/71.jpg"
//       }
//     }
//   },
//   {
//     "createdAt":
//         Timestamp.fromDate(DateTime.now().subtract(Duration(days: 800))),
//     "updatedAt":
//         Timestamp.fromDate(DateTime.now().subtract(Duration(days: 400))),
//     "aspects": {
//       "positive": ["cultural therapy", "societal issues"],
//       "negative": ["bipolar disorder"]
//     },
//     "subscription": {
//       "endsAt": Timestamp.fromDate(DateTime.now().add(Duration(days: 365))),
//       "plan": "gold",
//       "startedAt":
//           Timestamp.fromDate(DateTime.now().subtract(Duration(days: 400))),
//       "autoRenewal": false
//     },
//     "score": {"rating": 4.4, "amountRatings": 100},
//     "therapistInfo": {
//       "intro": "Therapist with a focus on cultural and societal issues.",
//       "location": {
//         "address": "Bağdat Cd",
//         "city": "Kocaeli",
//         "country": "TR",
//         "geolocation": GeoPoint(40.8533, 29.8815),
//         "stateProvince": "Giresun",
//         "zip": "31038"
//       },
//       "firstName": "Vildan",
//       "userInfoIsVerified": true,
//       "lastName": "Evliyaoğlu",
//       "specializations": ["psychologist", "cultural therapist"],
//       "spokenLanguages": ["tr", "en"],
//       "professionalCertificates": [
//         {
//           "yearObtained": 1980,
//           "photoUrl":
//               "https://www.4icu.org/i/programs-courses-degrees/graduate-diploma-of-psychology-500x356.png",
//           "title": "Masters in Social Work",
//           "type": "master",
//           "institution": "Istanbul University",
//           "verified": true
//         }
//       ],
//       "profilePictureUrl": {
//         "large": "https://randomuser.me/api/portraits/women/65.jpg",
//         "small": "https://randomuser.me/api/portraits/women/65.jpg",
//         "thumb": "https://randomuser.me/api/portraits/women/65.jpg"
//       }
//     }
//   },
//   {
//     "createdAt":
//         Timestamp.fromDate(DateTime.now().subtract(Duration(days: 900))),
//     "updatedAt":
//         Timestamp.fromDate(DateTime.now().subtract(Duration(days: 450))),
//     "aspects": {
//       "positive": ["adolescent therapy", "behavioral therapy"],
//       "negative": ["addiction"]
//     },
//     "subscription": {
//       "endsAt": Timestamp.fromDate(DateTime.now().add(Duration(days: 180))),
//       "plan": "silver",
//       "startedAt":
//           Timestamp.fromDate(DateTime.now().subtract(Duration(days: 450))),
//       "autoRenewal": true
//     },
//     "score": {"rating": 4.3, "amountRatings": 90},
//     "therapistInfo": {
//       "intro": "Psychologist specializing in adolescent therapy.",
//       "location": {
//         "address": "کلاهدوز",
//         "city": "Sabzevar",
//         "country": "IR",
//         "geolocation": GeoPoint(36.2126, 57.677),
//         "stateProvince": "Lorestan",
//         "zip": "74899"
//       },
//       "firstName": "Mahya",
//       "userInfoIsVerified": false,
//       "lastName": "Neko Nazari",
//       "specializations": ["psychologist", "adolescent therapist"],
//       "spokenLanguages": ["fa", "en"],
//       "professionalCertificates": [
//         {
//           "yearObtained": 1995,
//           "photoUrl":
//               "https://www.4icu.org/i/programs-courses-degrees/graduate-diploma-of-psychology-500x356.png",
//           "title": "PhD in Adolescent Psychology",
//           "type": "doctorate",
//           "institution": "University of Tehran",
//           "verified": true
//         }
//       ],
//       "profilePictureUrl": {
//         "large": "https://randomuser.me/api/portraits/women/56.jpg",
//         "small": "https://randomuser.me/api/portraits/women/56.jpg",
//         "thumb": "https://randomuser.me/api/portraits/women/56.jpg"
//       }
//     }
//   },
//   {
//     "createdAt":
//         Timestamp.fromDate(DateTime.now().subtract(Duration(days: 1000))),
//     "updatedAt":
//         Timestamp.fromDate(DateTime.now().subtract(Duration(days: 500))),
//     "aspects": {
//       "positive": ["anxiety", "depression"],
//       "negative": ["phobia"]
//     },
//     "subscription": {
//       "endsAt": Timestamp.fromDate(DateTime.now().add(Duration(days: 730))),
//       "plan": "platinum",
//       "startedAt":
//           Timestamp.fromDate(DateTime.now().subtract(Duration(days: 500))),
//       "autoRenewal": false
//     },
//     "score": {"rating": 4.6, "amountRatings": 110},
//     "therapistInfo": {
//       "intro": "Therapist specializing in anxiety and depression.",
//       "location": {
//         "address": "Park Danshjo",
//         "city": "Dezful",
//         "country": "IR",
//         "geolocation": GeoPoint(32.383, 48.423),
//         "stateProvince": "Hormozgan",
//         "zip": "53548"
//       },
//       "firstName": "Elena",
//       "userInfoIsVerified": false,
//       "lastName": "Sultani Nejad",
//       "specializations": ["psychologist", "counselor"],
//       "spokenLanguages": ["fa", "en"],
//       "professionalCertificates": [
//         {
//           "yearObtained": 2000,
//           "photoUrl":
//               "https://www.4icu.org/i/programs-courses-degrees/graduate-diploma-of-psychology-500x356.png",
//           "title": "Masters in Counseling",
//           "type": "master",
//           "institution": "University of Tehran",
//           "verified": true
//         }
//       ],
//       "profilePictureUrl": {
//         "large": "https://randomuser.me/api/portraits/women/9.jpg",
//         "small": "https://randomuser.me/api/portraits/women/9.jpg",
//         "thumb": "https://randomuser.me/api/portraits/women/9.jpg"
//       }
//     }
//   },
//   {
//     "createdAt":
//         Timestamp.fromDate(DateTime.now().subtract(Duration(days: 1100))),
//     "updatedAt":
//         Timestamp.fromDate(DateTime.now().subtract(Duration(days: 550))),
//     "aspects": {
//       "positive": ["family therapy", "child psychology"],
//       "negative": ["bipolar disorder"]
//     },
//     "subscription": {
//       "endsAt": Timestamp.fromDate(DateTime.now().add(Duration(days: 365))),
//       "plan": "gold",
//       "startedAt":
//           Timestamp.fromDate(DateTime.now().subtract(Duration(days: 550))),
//       "autoRenewal": true
//     },
//     "score": {"rating": 4.7, "amountRatings": 100},
//     "therapistInfo": {
//       "intro": "Specializes in family therapy and child psychology.",
//       "location": {
//         "address": "Manor Road",
//         "city": "Bandon",
//         "country": "IE",
//         "geolocation": GeoPoint(51.7462, -8.742),
//         "stateProvince": "Cork City",
//         "zip": "78121"
//       },
//       "firstName": "Ashley",
//       "userInfoIsVerified": true,
//       "lastName": "Willis",
//       "specializations": ["psychologist", "child psychologist"],
//       "spokenLanguages": ["en"],
//       "professionalCertificates": [
//         {
//           "yearObtained": 2010,
//           "photoUrl":
//               "https://www.4icu.org/i/programs-courses-degrees/graduate-diploma-of-psychology-500x356.png",
//           "title": "PhD in Child Psychology",
//           "type": "doctorate",
//           "institution": "Trinity College Dublin",
//           "verified": true
//         }
//       ],
//       "profilePictureUrl": {
//         "large": "https://randomuser.me/api/portraits/women/0.jpg",
//         "small": "https://randomuser.me/api/portraits/women/0.jpg",
//         "thumb": "https://randomuser.me/api/portraits/women/0.jpg"
//       }
//     }
//   },
//   {
//     "createdAt":
//         Timestamp.fromDate(DateTime.now().subtract(Duration(days: 1200))),
//     "updatedAt":
//         Timestamp.fromDate(DateTime.now().subtract(Duration(days: 600))),
//     "aspects": {
//       "positive": ["cognitive behavioral therapy", "depression"],
//       "negative": ["bipolar disorder"]
//     },
//     "subscription": {
//       "endsAt": Timestamp.fromDate(DateTime.now().add(Duration(days: 180))),
//       "plan": "silver",
//       "startedAt":
//           Timestamp.fromDate(DateTime.now().subtract(Duration(days: 600))),
//       "autoRenewal": false
//     },
//     "score": {"rating": 4.4, "amountRatings": 130},
//     "therapistInfo": {
//       "intro": "Psychologist specializing in cognitive behavioral therapy.",
//       "location": {
//         "address": "Moghadas Ardabili",
//         "city": "Mashhad",
//         "country": "IR",
//         "geolocation": GeoPoint(36.2605, 59.6168),
//         "stateProvince": "South Khorasan",
//         "zip": "40338"
//       },
//       "firstName": "Parsa",
//       "userInfoIsVerified": true,
//       "lastName": "Parsa",
//       "specializations": ["psychologist", "cognitive therapist"],
//       "spokenLanguages": ["fa", "en"],
//       "professionalCertificates": [
//         {
//           "yearObtained": 1999,
//           "photoUrl":
//               "https://www.4icu.org/i/programs-courses-degrees/graduate-diploma-of-psychology-500x356.png",
//           "title": "PhD in Cognitive Psychology",
//           "type": "doctorate",
//           "institution": "Ferdowsi University of Mashhad",
//           "verified": true
//         }
//       ],
//       "profilePictureUrl": {
//         "large": "https://randomuser.me/api/portraits/men/54.jpg",
//         "small": "https://randomuser.me/api/portraits/men/54.jpg",
//         "thumb": "https://randomuser.me/api/portraits/men/54.jpg"
//       }
//     }
//   },
//   {
//     "createdAt":
//         Timestamp.fromDate(DateTime.now().subtract(Duration(days: 1300))),
//     "updatedAt":
//         Timestamp.fromDate(DateTime.now().subtract(Duration(days: 650))),
//     "aspects": {
//       "positive": ["geriatric therapy", "family therapy"],
//       "negative": ["eating disorder"]
//     },
//     "subscription": {
//       "endsAt": Timestamp.fromDate(DateTime.now().add(Duration(days: 365))),
//       "plan": "gold",
//       "startedAt":
//           Timestamp.fromDate(DateTime.now().subtract(Duration(days: 650))),
//       "autoRenewal": true
//     },
//     "score": {"rating": 4.6, "amountRatings": 90},
//     "therapistInfo": {
//       "intro": "Geriatric therapist specializing in family therapy.",
//       "location": {
//         "address": "Valley View Ln",
//         "city": "Busselton",
//         "country": "AU",
//         "geolocation": GeoPoint(-33.6525, 115.345),
//         "stateProvince": "South Australia",
//         "zip": "8909"
//       },
//       "firstName": "Nellie",
//       "userInfoIsVerified": true,
//       "lastName": "Nelson",
//       "specializations": ["psychologist", "geriatric therapist"],
//       "spokenLanguages": ["en"],
//       "professionalCertificates": [
//         {
//           "yearObtained": 2005,
//           "photoUrl":
//               "https://www.4icu.org/i/programs-courses-degrees/graduate-diploma-of-psychology-500x356.png",
//           "title": "PhD in Geriatric Psychology",
//           "type": "doctorate",
//           "institution": "University of Western Australia",
//           "verified": true
//         }
//       ],
//       "profilePictureUrl": {
//         "large": "https://randomuser.me/api/portraits/women/10.jpg",
//         "small": "https://randomuser.me/api/portraits/women/10.jpg",
//         "thumb": "https://randomuser.me/api/portraits/women/10.jpg"
//       }
//     }
//   },
//   {
//     "createdAt":
//         Timestamp.fromDate(DateTime.now().subtract(Duration(days: 1400))),
//     "updatedAt":
//         Timestamp.fromDate(DateTime.now().subtract(Duration(days: 700))),
//     "aspects": {
//       "positive": ["anxiety", "depression"],
//       "negative": ["phobia"]
//     },
//     "subscription": {
//       "endsAt": Timestamp.fromDate(DateTime.now().add(Duration(days: 180))),
//       "plan": "silver",
//       "startedAt":
//           Timestamp.fromDate(DateTime.now().subtract(Duration(days: 700))),
//       "autoRenewal": false
//     },
//     "score": {"rating": 4.5, "amountRatings": 140},
//     "therapistInfo": {
//       "intro": "Specialist in treating anxiety and depression.",
//       "location": {
//         "address": "Tuam Street",
//         "city": "Hastings",
//         "country": "NZ",
//         "geolocation": GeoPoint(-39.638, 176.846),
//         "stateProvince": "Gisborne",
//         "zip": "99236"
//       },
//       "firstName": "Brooklyn",
//       "userInfoIsVerified": true,
//       "lastName": "Smith",
//       "specializations": ["psychologist", "counselor"],
//       "spokenLanguages": ["en"],
//       "professionalCertificates": [
//         {
//           "yearObtained": 2002,
//           "photoUrl":
//               "https://www.4icu.org/i/programs-courses-degrees/graduate-diploma-of-psychology-500x356.png",
//           "title": "Masters in Counseling",
//           "type": "master",
//           "institution": "University of Auckland",
//           "verified": true
//         }
//       ],
//       "profilePictureUrl": {
//         "large": "https://randomuser.me/api/portraits/women/1.jpg",
//         "small": "https://randomuser.me/api/portraits/women/1.jpg",
//         "thumb": "https://randomuser.me/api/portraits/women/1.jpg"
//       }
//     }
//   },
//   {
//     "createdAt":
//         Timestamp.fromDate(DateTime.now().subtract(Duration(days: 1500))),
//     "updatedAt":
//         Timestamp.fromDate(DateTime.now().subtract(Duration(days: 750))),
//     "aspects": {
//       "positive": ["trauma recovery", "post-traumatic growth"],
//       "negative": ["addiction"]
//     },
//     "subscription": {
//       "endsAt": Timestamp.fromDate(DateTime.now().add(Duration(days: 365))),
//       "plan": "gold",
//       "startedAt":
//           Timestamp.fromDate(DateTime.now().subtract(Duration(days: 750))),
//       "autoRenewal": true
//     },
//     "score": {"rating": 4.8, "amountRatings": 150},
//     "therapistInfo": {
//       "intro": "Specializes in trauma recovery and post-traumatic growth.",
//       "location": {
//         "address": "Place de L'Abbé-Basset",
//         "city": "Courtelary",
//         "country": "CH",
//         "geolocation": GeoPoint(47.1776, 7.0721),
//         "stateProvince": "Vaud",
//         "zip": "8425"
//       },
//       "firstName": "Mathias",
//       "userInfoIsVerified": true,
//       "lastName": "Guerin",
//       "specializations": ["psychologist", "trauma therapist"],
//       "spokenLanguages": ["fr", "en"],
//       "professionalCertificates": [
//         {
//           "yearObtained": 2003,
//           "photoUrl":
//               "https://www.4icu.org/i/programs-courses-degrees/graduate-diploma-of-psychology-500x356.png",
//           "title": "PhD in Clinical Psychology",
//           "type": "doctorate",
//           "institution": "University of Geneva",
//           "verified": true
//         }
//       ],
//       "profilePictureUrl": {
//         "large": "https://randomuser.me/api/portraits/men/66.jpg",
//         "small": "https://randomuser.me/api/portraits/men/66.jpg",
//         "thumb": "https://randomuser.me/api/portraits/men/66.jpg"
//       }
//     }
//   },
//   {
//     "createdAt":
//         Timestamp.fromDate(DateTime.now().subtract(Duration(days: 1600))),
//     "updatedAt":
//         Timestamp.fromDate(DateTime.now().subtract(Duration(days: 800))),
//     "aspects": {
//       "positive": ["cognitive behavioral therapy", "depression"],
//       "negative": ["bipolar disorder"]
//     },
//     "subscription": {
//       "endsAt": Timestamp.fromDate(DateTime.now().add(Duration(days: 180))),
//       "plan": "silver",
//       "startedAt":
//           Timestamp.fromDate(DateTime.now().subtract(Duration(days: 800))),
//       "autoRenewal": false
//     },
//     "score": {"rating": 4.4, "amountRatings": 130},
//     "therapistInfo": {
//       "intro":
//           "Specialist in cognitive behavioral therapy and treating depression.",
//       "location": {
//         "address": "Grove Road",
//         "city": "Ballinasloe",
//         "country": "IE",
//         "geolocation": GeoPoint(53.3277, -8.219),
//         "stateProvince": "Kilkenny",
//         "zip": "47434"
//       },
//       "firstName": "Derrick",
//       "userInfoIsVerified": true,
//       "lastName": "Reid",
//       "specializations": ["psychologist", "cognitive therapist"],
//       "spokenLanguages": ["en"],
//       "professionalCertificates": [
//         {
//           "yearObtained": 1995,
//           "photoUrl":
//               "https://www.4icu.org/i/programs-courses-degrees/graduate-diploma-of-psychology-500x356.png",
//           "title": "PhD in Cognitive Psychology",
//           "type": "doctorate",
//           "institution": "Trinity College Dublin",
//           "verified": true
//         }
//       ],
//       "profilePictureUrl": {
//         "large": "https://randomuser.me/api/portraits/men/41.jpg",
//         "small": "https://randomuser.me/api/portraits/men/41.jpg",
//         "thumb": "https://randomuser.me/api/portraits/men/41.jpg"
//       }
//     }
//   },
//   {
//     "createdAt":
//         Timestamp.fromDate(DateTime.now().subtract(Duration(days: 1700))),
//     "updatedAt":
//         Timestamp.fromDate(DateTime.now().subtract(Duration(days: 850))),
//     "aspects": {
//       "positive": ["cognitive behavioral therapy", "depression"],
//       "negative": ["bipolar disorder"]
//     },
//     "subscription": {
//       "endsAt": Timestamp.fromDate(DateTime.now().add(Duration(days: 365))),
//       "plan": "gold",
//       "startedAt":
//           Timestamp.fromDate(DateTime.now().subtract(Duration(days: 850))),
//       "autoRenewal": true
//     },
//     "score": {"rating": 4.7, "amountRatings": 180},
//     "therapistInfo": {
//       "intro":
//           "Experienced psychologist specializing in cognitive behavioral therapy.",
//       "location": {
//         "address": "Poplar Dr",
//         "city": "Toowoomba",
//         "country": "AU",
//         "geolocation": GeoPoint(-27.5606, 151.953),
//         "stateProvince": "New South Wales",
//         "zip": "6879"
//       },
//       "firstName": "Vernon",
//       "userInfoIsVerified": true,
//       "lastName": "Washington",
//       "specializations": ["psychologist", "cognitive therapist"],
//       "spokenLanguages": ["en"],
//       "professionalCertificates": [
//         {
//           "yearObtained": 2001,
//           "photoUrl":
//               "https://www.4icu.org/i/programs-courses-degrees/graduate-diploma-of-psychology-500x356.png",
//           "title": "PhD in Cognitive Psychology",
//           "type": "doctorate",
//           "institution": "University of Queensland",
//           "verified": true
//         }
//       ],
//       "profilePictureUrl": {
//         "large": "https://randomuser.me/api/portraits/men/88.jpg",
//         "small": "https://randomuser.me/api/portraits/men/88.jpg",
//         "thumb": "https://randomuser.me/api/portraits/men/88.jpg"
//       }
//     }
//   },
//   {
//     "createdAt":
//         Timestamp.fromDate(DateTime.now().subtract(Duration(days: 1800))),
//     "updatedAt":
//         Timestamp.fromDate(DateTime.now().subtract(Duration(days: 900))),
//     "aspects": {
//       "positive": ["family therapy", "child psychology"],
//       "negative": ["bipolar disorder"]
//     },
//     "subscription": {
//       "endsAt": Timestamp.fromDate(DateTime.now().add(Duration(days: 180))),
//       "plan": "silver",
//       "startedAt":
//           Timestamp.fromDate(DateTime.now().subtract(Duration(days: 900))),
//       "autoRenewal": false
//     },
//     "score": {"rating": 4.6, "amountRatings": 100},
//     "therapistInfo": {
//       "intro": "Specializes in family therapy and child psychology.",
//       "location": {
//         "address": "Moghadas Ardabili",
//         "city": "Mashhad",
//         "country": "IR",
//         "geolocation": GeoPoint(36.2605, 59.6168),
//         "stateProvince": "South Khorasan",
//         "zip": "40338"
//       },
//       "firstName": "Molina",
//       "userInfoIsVerified": true,
//       "lastName": "Rezaiyan",
//       "specializations": ["psychologist", "child psychologist"],
//       "spokenLanguages": ["fa", "en"],
//       "professionalCertificates": [
//         {
//           "yearObtained": 2005,
//           "photoUrl":
//               "https://www.4icu.org/i/programs-courses-degrees/graduate-diploma-of-psychology-500x356.png",
//           "title": "PhD in Child Psychology",
//           "type": "doctorate",
//           "institution": "Ferdowsi University of Mashhad",
//           "verified": true
//         }
//       ],
//       "profilePictureUrl": {
//         "large": "https://randomuser.me/api/portraits/women/10.jpg",
//         "small": "https://randomuser.me/api/portraits/women/10.jpg",
//         "thumb": "https://randomuser.me/api/portraits/women/10.jpg"
//       }
//     }
//   }
// ];
