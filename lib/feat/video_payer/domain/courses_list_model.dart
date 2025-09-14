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
    description: 'Comprehensive course designed to prepare candidates thoroughly for the Nayab Subba Inspector examination, covering all essential subjects.',
    imageUrl: 'https://via.placeholder.com/300x200?text=Inspector+Prep',
    subjects: [
      Subject(
        id: '1',
        title: 'General Knowledge',
        description: 'This subject covers a broad range of topics including history, culture, major events, and current affairs essential for competitive exams.',
        chapters: [
          Chapter(
            id: '1',
            title: 'Chapter 1: History',
            description: 'Explore ancient civilizations, medieval eras, and modern historical developments shaping the world today.',
            videos: [
              Video(
                id: '1',
                title: 'Ancient Civilizations of the Las Vegas',
                url: 'https://www.youtube.com/watch?v=4dYCeWxKmzc',
                duration: '15:30',
                thumbnail: 'https://via.placeholder.com/150x100',
              ),
              Video(
                id: '2',
                title: 'Medieval Period',
                url: 'https://www.youtube.com/watch?v=0fkiJCXL6UM',
                duration: '12:45',
                thumbnail: 'https://via.placeholder.com/150x100',
              ),
              Video(
                id: '3',
                title: 'Modern History',
                url: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
                duration: '18:20',
                thumbnail: 'https://via.placeholder.com/150x100',
              ),
            ],
          ),
          Chapter(
            id: '2',
            title: 'Chapter 2: Politics',
            description: 'Understand the basics of political science, governance systems, and constitutional rights.',
            videos: [
              Video(
                id: '4',
                title: 'Constitution Basics',
                url: 'https://www.youtube.com/watch?v=QdSlK8J_vT0',
                duration: '20:15',
                thumbnail: 'https://via.placeholder.com/150x100',
              ),
              Video(
                id: '5',
                title: 'Fundamental Rights',
                url: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
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
        description: 'Study both physical landscapes and human geography with a focus on environmental and cultural factors.',
        chapters: [
          Chapter(
            id: '4',
            title: 'Chapter 1: Physical Geography',
            description: 'A detailed look at earth’s landforms, climate zones, and major geographic processes.',
            videos: [
              Video(
                id: '8',
                title: 'Mountain Formation',
                url: 'https://www.youtube.com/watch?v=lw2I96X2bX8',
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
    title: 'Officer Cadet',
    description: 'Extensive preparation course for aspiring Officer Cadets, focusing on knowledge and skills required for successful selection.',
    imageUrl: 'https://via.placeholder.com/300x200?text=Inspector+Prep',
    subjects: [
      Subject(
        id: '1',
        title: 'General Knowledge',
        description: 'Covers essential general knowledge topics including history, current affairs, and key concepts useful for competitive tests.',
        chapters: [
          Chapter(
            id: '1',
            title: 'Chapter 1: History',
            description: 'An overview of historical periods from ancient times to the modern age.',
            videos: [
              Video(
                id: '1',
                title: 'Ancient Civilizations is here for the globalization',
                url: 'https://www.youtube.com/watch?v=4dYCeWxKmzc',
                duration: '15:30',
                thumbnail: 'https://via.placeholder.com/150x100',
              ),
              Video(
                id: '2',
                title: 'Medieval Period',
                url: 'https://www.youtube.com/watch?v=0fkiJCXL6UM',
                duration: '12:45',
                thumbnail: 'https://via.placeholder.com/150x100',
              ),
              Video(
                id: '3',
                title: 'Modern History',
                url: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
                duration: '18:20',
                thumbnail: 'https://via.placeholder.com/150x100',
              ),
            ],
          ),
          Chapter(
            id: '2',
            title: 'Chapter 2: Politics',
            description: 'Fundamentals of political science with focus on constitutions and rights.',
            videos: [
              Video(
                id: '4',
                title: 'Constitution Basics',
                url: 'https://www.youtube.com/watch?v=QdSlK8J_vT0',
                duration: '20:15',
                thumbnail: 'https://via.placeholder.com/150x100',
              ),
              Video(
                id: '5',
                title: 'Fundamental Rights',
                url: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
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
        description: 'Physical and human geography concepts with emphasis on geography’s role in societal development.',
        chapters: [
          Chapter(
            id: '4',
            title: 'Chapter 1: Physical Geography',
            description: 'Exploring earth’s physical features and climatic conditions.',
            videos: [
              Video(
                id: '8',
                title: 'Mountain Formation',
                url: 'https://www.youtube.com/watch?v=lw2I96X2bX8',
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
    title: 'Inspector Preparation for the Nepal Police',
    description: 'All-inclusive Inspector exam preparation course with focus on knowledge, mathematics, and geography.',
    imageUrl: 'https://via.placeholder.com/300x200?text=Inspector+Prep',
    subjects: [
      Subject(
        id: '1',
        title: 'General Knowledge',
        description: 'A deep dive into general knowledge with historical and political science foundations.',
        chapters: [
          Chapter(
            id: '1',
            title: 'Chapter 1: History',
            description: 'Insights into historical events from various periods.',
            videos: [
              Video(
                id: '1',
                title: 'Ancient Civilizations',
                url: 'https://www.youtube.com/watch?v=4dYCeWxKmzc',
                duration: '15:30',
                thumbnail: 'https://via.placeholder.com/150x100',
              ),
              Video(
                id: '2',
                title: 'Medieval Period',
                url: 'https://www.youtube.com/watch?v=0fkiJCXL6UM',
                duration: '12:45',
                thumbnail: 'https://via.placeholder.com/150x100',
              ),
              Video(
                id: '3',
                title: 'Modern History',
                url: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
                duration: '18:20',
                thumbnail: 'https://via.placeholder.com/150x100',
              ),
            ],
          ),
          Chapter(
            id: '2',
            title: 'Chapter 2: Politics',
            description: 'Basic concepts in political science and human rights.',
            videos: [
              Video(
                id: '4',
                title: 'Constitution Basics',
                url: 'https://www.youtube.com/watch?v=QdSlK8J_vT0',
                duration: '20:15',
                thumbnail: 'https://via.placeholder.com/150x100',
              ),
              Video(
                id: '5',
                title: 'Fundamental Rights',
                url: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
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
        description: 'Focus on concepts in algebra and problem-solving techniques.',
        chapters: [
          Chapter(
            id: '3',
            title: 'Chapter 1: Algebra',
            description: 'Covers a range from basic to advanced algebra topics.',
            videos: [
              Video(
                id: '6',
                title: 'Linear Equations',
                url: 'https://www.youtube.com/watch?v=ykLjqpj7kP0',
                duration: '14:20',
                thumbnail: 'https://via.placeholder.com/150x100',
              ),
              Video(
                id: '7',
                title: 'Quadratic Equations',
                url: 'https://www.youtube.com/watch?v=NJSfT9r4pKw',
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
        description: 'Detailed study of physical and human geography essential for exams.',
        chapters: [
          Chapter(
            id: '4',
            title: 'Chapter 1: Physical Geography',
            description: 'Understanding landforms, climate systems, and geographical processes.',
            videos: [
              Video(
                id: '8',
                title: 'Mountain Formation',
                url: 'https://www.youtube.com/watch?v=lw2I96X2bX8',
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
    description: 'Detailed preparation course targeting Chief Secretary candidates for competitive exams with core subjects.',
    imageUrl: 'https://via.placeholder.com/300x200?text=Inspector+Prep',
    subjects: [
      Subject(
        id: '1',
        title: 'General Knowledge',
        description: 'Extensive coverage of current affairs, history, and cultural knowledge.',
        chapters: [
          Chapter(
            id: '1',
            title: 'Chapter 1: History',
            description: 'Examines historical events from ancient times to the present.',
            videos: [
              Video(
                id: '1',
                title: 'Ancient Civilizations',
                url: 'https://www.youtube.com/watch?v=4dYCeWxKmzc',
                duration: '15:30',
                thumbnail: 'https://via.placeholder.com/150x100',
              ),
              Video(
                id: '2',
                title: 'Medieval Period',
                url: 'https://www.youtube.com/watch?v=0fkiJCXL6UM',
                duration: '12:45',
                thumbnail: 'https://via.placeholder.com/150x100',
              ),
              Video(
                id: '3',
                title: 'Modern History',
                url: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
                duration: '18:20',
                thumbnail: 'https://via.placeholder.com/150x100',
              ),
            ],
          ),
          Chapter(
            id: '2',
            title: 'Chapter 2: Politics',
            description: 'Key political concepts and constitutional knowledge for civil service exams.',
            videos: [
              Video(
                id: '4',
                title: 'Constitution Basics',
                url: 'https://www.youtube.com/watch?v=QdSlK8J_vT0',
                duration: '20:15',
                thumbnail: 'https://via.placeholder.com/150x100',
              ),
              Video(
                id: '5',
                title: 'Fundamental Rights',
                url: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
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
        description: 'In-depth coursework on algebraic concepts and mathematical problem solving.',
        chapters: [
          Chapter(
            id: '3',
            title: 'Chapter 1: Algebra',
            description: 'Stepwise approach from basic linear equations to complex quadratic problems.',
            videos: [
              Video(
                id: '6',
                title: 'Linear Equations',
                url: 'https://www.youtube.com/watch?v=ykLjqpj7kP0',
                duration: '14:20',
                thumbnail: 'https://via.placeholder.com/150x100',
              ),
              Video(
                id: '7',
                title: 'Quadratic Equations',
                url: 'https://www.youtube.com/watch?v=NJSfT9r4pKw',
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
        description: 'Comprehensive study of physical geography and environmental science.',
        chapters: [
          Chapter(
            id: '4',
            title: 'Chapter 1: Physical Geography',
            description: 'Focus on natural formations, climate impact, and terrain analysis.',
            videos: [
              Video(
                id: '8',
                title: 'Mountain Formation',
                url: 'https://www.youtube.com/watch?v=lw2I96X2bX8',
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



