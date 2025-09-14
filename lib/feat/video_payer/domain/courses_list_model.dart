class Course {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final List<Subject> subjects;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.subjects,
  });
}

class Subject {
  final String id;
  final String title;
  final String description;
  final List<Chapter> chapters;

  Subject({
    required this.id,
    required this.title,
    required this.description,
    required this.chapters,
  });
}

class Chapter {
  final String id;
  final String title;
  final String description;
  final List<Video> videos;

  Chapter({
    required this.id,
    required this.title,
    required this.description,
    required this.videos,
  });
}

class Video {
  final String id;
  final String title;
  final String url;
  final String duration;
  final String thumbnail;

  Video({
    required this.id,
    required this.title,
    required this.url,
    required this.duration,
    required this.thumbnail,
  });
}

final List<Course> sampleCourses = [
  Course(
    id: '1',
    title: 'Nayab Subba',
    description: 'Complete preparation course for Inspector examination',
    imageUrl: 'https://via.placeholder.com/300x200?text=Inspector+Prep',
    subjects: [
      Subject(
        id: '1',
        title: 'General Knowledge',
        description: 'Essential GK topics for Inspector exam',
        chapters: [
          Chapter(
            id: '1',
            title: 'Chapter 1: History',
            description: 'Ancient and Modern History',
            videos: [
              Video(
                id: '1',
                title: 'Ancient Civilizations',
                url:
                    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
                duration: '15:30',
                thumbnail: 'https://via.placeholder.com/150x100',
              ),
              Video(
                id: '2',
                title: 'Medieval Period',
                url:
                    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
                duration: '12:45',
                thumbnail: 'https://via.placeholder.com/150x100',
              ),
              Video(
                id: '3',
                title: 'Modern History',
                url:
                    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
                duration: '18:20',
                thumbnail: 'https://via.placeholder.com/150x100',
              ),
            ],
          ),
          Chapter(
            id: '2',
            title: 'Chapter 2: Politics',
            description: 'Political Science fundamentals',
            videos: [
              Video(
                id: '4',
                title: 'Constitution Basics',
                url:
                    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
                duration: '20:15',
                thumbnail: 'https://via.placeholder.com/150x100',
              ),
              Video(
                id: '5',
                title: 'Fundamental Rights',
                url:
                    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
                duration: '16:30',
                thumbnail: 'https://via.placeholder.com/150x100',
              ),
            ],
          ),
        ],
      ),
      Subject(
        id: '3',
        title: 'Geography',
        description: 'Physical and human geography',
        chapters: [
          Chapter(
            id: '4',
            title: 'Chapter 1: Physical Geography',
            description: 'Landforms and climate',
            videos: [
              Video(
                id: '8',
                title: 'Mountain Formation',
                url:
                    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4',
                duration: '13:55',
                thumbnail: 'https://via.placeholder.com/150x100',
              ),
            ],
          ),
        ],
      ),
    ],
  ),
  Course(
    id: '2',
    title: 'Officer Candet',
    description: 'Complete preparation course for Inspector examination',
    imageUrl: 'https://via.placeholder.com/300x200?text=Inspector+Prep',
    subjects: [
      Subject(
        id: '1',
        title: 'General Knowledge',
        description: 'Essential GK topics for Inspector exam',
        chapters: [
          Chapter(
            id: '1',
            title: 'Chapter 1: History',
            description: 'Ancient and Modern History',
            videos: [
              Video(
                id: '1',
                title: 'Ancient Civilizations',
                url:
                    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
                duration: '15:30',
                thumbnail: 'https://via.placeholder.com/150x100',
              ),
              Video(
                id: '2',
                title: 'Medieval Period',
                url:
                    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
                duration: '12:45',
                thumbnail: 'https://via.placeholder.com/150x100',
              ),
              Video(
                id: '3',
                title: 'Modern History',
                url:
                    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
                duration: '18:20',
                thumbnail: 'https://via.placeholder.com/150x100',
              ),
            ],
          ),
          Chapter(
            id: '2',
            title: 'Chapter 2: Politics',
            description: 'Political Science fundamentals',
            videos: [
              Video(
                id: '4',
                title: 'Constitution Basics',
                url:
                    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
                duration: '20:15',
                thumbnail: 'https://via.placeholder.com/150x100',
              ),
              Video(
                id: '5',
                title: 'Fundamental Rights',
                url:
                    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
                duration: '16:30',
                thumbnail: 'https://via.placeholder.com/150x100',
              ),
            ],
          ),
        ],
      ),
      Subject(
        id: '2',
        title: 'Geography',
        description: 'Physical and human geography',
        chapters: [
          Chapter(
            id: '4',
            title: 'Chapter 1: Physical Geography',
            description: 'Landforms and climate',
            videos: [
              Video(
                id: '8',
                title: 'Mountain Formation',
                url:
                    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4',
                duration: '13:55',
                thumbnail: 'https://via.placeholder.com/150x100',
              ),
            ],
          ),
        ],
      ),
    ],
  ),
  Course(
    id: '3',
    title: 'Inspector Preparation',
    description: 'Complete preparation course for Inspector examination',
    imageUrl: 'https://via.placeholder.com/300x200?text=Inspector+Prep',
    subjects: [
      Subject(
        id: '1',
        title: 'General Knowledge',
        description: 'Essential GK topics for Inspector exam',
        chapters: [
          Chapter(
            id: '1',
            title: 'Chapter 1: History',
            description: 'Ancient and Modern History',
            videos: [
              Video(
                id: '1',
                title: 'Ancient Civilizations',
                url:
                    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
                duration: '15:30',
                thumbnail: 'https://via.placeholder.com/150x100',
              ),
              Video(
                id: '2',
                title: 'Medieval Period',
                url:
                    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
                duration: '12:45',
                thumbnail: 'https://via.placeholder.com/150x100',
              ),
              Video(
                id: '3',
                title: 'Modern History',
                url:
                    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
                duration: '18:20',
                thumbnail: 'https://via.placeholder.com/150x100',
              ),
            ],
          ),
          Chapter(
            id: '2',
            title: 'Chapter 2: Politics',
            description: 'Political Science fundamentals',
            videos: [
              Video(
                id: '4',
                title: 'Constitution Basics',
                url:
                    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
                duration: '20:15',
                thumbnail: 'https://via.placeholder.com/150x100',
              ),
              Video(
                id: '5',
                title: 'Fundamental Rights',
                url:
                    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
                duration: '16:30',
                thumbnail: 'https://via.placeholder.com/150x100',
              ),
            ],
          ),
        ],
      ),
      Subject(
        id: '2',
        title: 'Mathematics',
        description: 'Mathematical concepts and problem solving',
        chapters: [
          Chapter(
            id: '3',
            title: 'Chapter 1: Algebra',
            description: 'Basic to advanced algebra',
            videos: [
              Video(
                id: '6',
                title: 'Linear Equations',
                url:
                    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
                duration: '14:20',
                thumbnail: 'https://via.placeholder.com/150x100',
              ),
              Video(
                id: '7',
                title: 'Quadratic Equations',
                url:
                    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4',
                duration: '17:45',
                thumbnail: 'https://via.placeholder.com/150x100',
              ),
            ],
          ),
        ],
      ),
      Subject(
        id: '3',
        title: 'Geography',
        description: 'Physical and human geography',
        chapters: [
          Chapter(
            id: '4',
            title: 'Chapter 1: Physical Geography',
            description: 'Landforms and climate',
            videos: [
              Video(
                id: '8',
                title: 'Mountain Formation',
                url:
                    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4',
                duration: '13:55',
                thumbnail: 'https://via.placeholder.com/150x100',
              ),
            ],
          ),
        ],
      ),
    ],
  ),
  Course(
    id: '4',
    title: 'Chief Secretary Preparation',
    description: 'Complete preparation course for Inspector examination',
    imageUrl: 'https://via.placeholder.com/300x200?text=Inspector+Prep',
    subjects: [
      Subject(
        id: '1',
        title: 'General Knowledge',
        description: 'Essential GK topics for Inspector exam',
        chapters: [
          Chapter(
            id: '1',
            title: 'Chapter 1: History',
            description: 'Ancient and Modern History',
            videos: [
              Video(
                id: '1',
                title: 'Ancient Civilizations',
                url:
                    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
                duration: '15:30',
                thumbnail: 'https://via.placeholder.com/150x100',
              ),
              Video(
                id: '2',
                title: 'Medieval Period',
                url:
                    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
                duration: '12:45',
                thumbnail: 'https://via.placeholder.com/150x100',
              ),
              Video(
                id: '3',
                title: 'Modern History',
                url:
                    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
                duration: '18:20',
                thumbnail: 'https://via.placeholder.com/150x100',
              ),
            ],
          ),
          Chapter(
            id: '2',
            title: 'Chapter 2: Politics',
            description: 'Political Science fundamentals',
            videos: [
              Video(
                id: '4',
                title: 'Constitution Basics',
                url:
                    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
                duration: '20:15',
                thumbnail: 'https://via.placeholder.com/150x100',
              ),
              Video(
                id: '5',
                title: 'Fundamental Rights',
                url:
                    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
                duration: '16:30',
                thumbnail: 'https://via.placeholder.com/150x100',
              ),
            ],
          ),
        ],
      ),
      Subject(
        id: '2',
        title: 'Mathematics',
        description: 'Mathematical concepts and problem solving',
        chapters: [
          Chapter(
            id: '3',
            title: 'Chapter 1: Algebra',
            description: 'Basic to advanced algebra',
            videos: [
              Video(
                id: '6',
                title: 'Linear Equations',
                url:
                    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
                duration: '14:20',
                thumbnail: 'https://via.placeholder.com/150x100',
              ),
              Video(
                id: '7',
                title: 'Quadratic Equations',
                url:
                    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4',
                duration: '17:45',
                thumbnail: 'https://via.placeholder.com/150x100',
              ),
            ],
          ),
        ],
      ),
      Subject(
        id: '3',
        title: 'Geography',
        description: 'Physical and human geography',
        chapters: [
          Chapter(
            id: '4',
            title: 'Chapter 1: Physical Geography',
            description: 'Landforms and climate',
            videos: [
              Video(
                id: '8',
                title: 'Mountain Formation',
                url:
                    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4',
                duration: '13:55',
                thumbnail: 'https://via.placeholder.com/150x100',
              ),
            ],
          ),
        ],
      ),
    ],
  ),
];
