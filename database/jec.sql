CREATE TABLE users (
    id CHAR(36) NOT NULL PRIMARY KEY,
    username VARCHAR(30) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(20) UNIQUE,
    password_hash TEXT,
    auth_provider VARCHAR(20) DEFAULT 'local',
    email_verified BOOLEAN DEFAULT FALSE,
    phone_verified BOOLEAN DEFAULT FALSE,
    account_status VARCHAR(20) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL,
    deleted_at TIMESTAMP NULL
);

CREATE TABLE user_profiles (
    id CHAR(36) NOT NULL PRIMARY KEY,
    user_id CHAR(36) NOT NULL,

    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50),

    avatar_url TEXT,
    cover_photo_url TEXT,

    bio TEXT,

    gender VARCHAR(20),

    date_of_birth DATE,

    city VARCHAR(100),

    linkedin_url TEXT,
    github_url TEXT,
    portfolio_url TEXT,

    skills JSON,
    interests JSON,

    profile_visibility ENUM('public', 'private', 'friends')
        DEFAULT 'public',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_user_profile_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE,

    UNIQUE KEY uk_user_profile_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE colleges (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    name VARCHAR(255) NOT NULL,

    short_name VARCHAR(100),

    slug VARCHAR(255) NOT NULL UNIQUE,

    logo_url TEXT,

    cover_image_url TEXT,

    description TEXT,

    established_year YEAR,

    address TEXT,

    city VARCHAR(100) NOT NULL,

    district VARCHAR(100),

    pincode VARCHAR(10),

    latitude DECIMAL(10,8),

    longitude DECIMAL(11,8),

    email VARCHAR(255),

    phone VARCHAR(20),

    website_url VARCHAR(255),

    admission_url VARCHAR(255),

    is_verified BOOLEAN NOT NULL DEFAULT FALSE,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



CREATE TABLE departments (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    college_id BIGINT UNSIGNED NOT NULL,

    name VARCHAR(100) NOT NULL,

    short_name VARCHAR(20),

    description TEXT,

    hod_name VARCHAR(100),

    email VARCHAR(255),

    phone VARCHAR(20),

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_department_college
        FOREIGN KEY (college_id)
        REFERENCES colleges(id)
        ON DELETE CASCADE,

    UNIQUE KEY unique_department (
        college_id,
        name
    ),

    INDEX idx_college (college_id)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;


CREATE TABLE college_affiliations (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    user_id CHAR(36) NOT NULL,

    college_id BIGINT UNSIGNED NOT NULL,

    status ENUM('prospective','student','alumni')
        NOT NULL DEFAULT 'prospective',

    department VARCHAR(100) NOT NULL,

    course VARCHAR(100) NOT NULL,

    admission_year YEAR,

    graduation_year YEAR,

    student_id VARCHAR(50),

    is_verified BOOLEAN DEFAULT FALSE,

    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_affiliation_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_affiliation_college
        FOREIGN KEY (college_id)
        REFERENCES colleges(id)
        ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE posts (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    user_id CHAR(36) NOT NULL,
    college_id BIGINT UNSIGNED NOT NULL,
    department_id BIGINT UNSIGNED NULL,

    title VARCHAR(255),

    content TEXT NOT NULL,

    type ENUM(
        'general',
        'announcement',
        'question',
        'event',
        'achievement'
    ) DEFAULT 'general',

    visibility ENUM(
        'public',
        'students',
        'alumni'
    ) DEFAULT 'public',

    is_pinned BOOLEAN DEFAULT FALSE,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,

    FOREIGN KEY (college_id) REFERENCES colleges(id) ON DELETE CASCADE,

    FOREIGN KEY (department_id) REFERENCES departments(id)
        ON DELETE SET NULL
);

CREATE TABLE comments (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    post_id BIGINT UNSIGNED NOT NULL,

    user_id CHAR(36) NOT NULL,

    parent_comment_id BIGINT UNSIGNED NULL,

    content TEXT NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (post_id) REFERENCES posts(id)
        ON DELETE CASCADE,

    FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE CASCADE,

    FOREIGN KEY (parent_comment_id)
        REFERENCES comments(id)
        ON DELETE CASCADE
);

CREATE TABLE likes (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    user_id CHAR(36) NOT NULL,

    target_type ENUM(
        'post',
        'comment',
        'review',
        'answer'
    ) NOT NULL,

    target_id BIGINT UNSIGNED NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    UNIQUE KEY unique_like (
        user_id,
        target_type,
        target_id
    ),

    FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
);

CREATE TABLE reviews (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    user_id CHAR(36) NOT NULL,

    college_id BIGINT UNSIGNED NOT NULL,

    rating TINYINT NOT NULL,

    title VARCHAR(255),

    review TEXT NOT NULL,

    anonymous BOOLEAN DEFAULT FALSE,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE,

    FOREIGN KEY (college_id)
        REFERENCES colleges(id)
        ON DELETE CASCADE
);

CREATE TABLE questions (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    user_id CHAR(36) NOT NULL,

    college_id BIGINT UNSIGNED NOT NULL,

    department_id BIGINT UNSIGNED NULL,

    title VARCHAR(255) NOT NULL,

    description TEXT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE,

    FOREIGN KEY (college_id)
        REFERENCES colleges(id)
        ON DELETE CASCADE,

    FOREIGN KEY (department_id)
        REFERENCES departments(id)
        ON DELETE SET NULL
);

CREATE TABLE answers (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    question_id BIGINT UNSIGNED NOT NULL,

    user_id CHAR(36) NOT NULL,

    answer TEXT NOT NULL,

    is_best BOOLEAN DEFAULT FALSE,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (question_id)
        REFERENCES questions(id)
        ON DELETE CASCADE,

    FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
);

CREATE TABLE clubs (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    college_id BIGINT UNSIGNED NOT NULL,

    name VARCHAR(150) NOT NULL,

    description TEXT,

    logo_url TEXT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (college_id)
        REFERENCES colleges(id)
        ON DELETE CASCADE
);

CREATE TABLE events (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    college_id BIGINT UNSIGNED NOT NULL,

    club_id BIGINT UNSIGNED NULL,

    title VARCHAR(255) NOT NULL,

    description TEXT,

    venue VARCHAR(255),

    starts_at DATETIME NOT NULL,

    ends_at DATETIME,

    visibility ENUM(
        'public',
        'students',
        'alumni'
    ) DEFAULT 'public',

    created_by CHAR(36) NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (college_id)
        REFERENCES colleges(id)
        ON DELETE CASCADE,

    FOREIGN KEY (club_id)
        REFERENCES clubs(id)
        ON DELETE SET NULL,

    FOREIGN KEY (created_by)
        REFERENCES users(id)
        ON DELETE CASCADE
);

CREATE TABLE media (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    user_id CHAR(36) NOT NULL,

    target_type ENUM(
        'post',
        'review',
        'event',
        'college'
    ) NOT NULL,

    target_id BIGINT UNSIGNED NOT NULL,

    file_url TEXT NOT NULL,

    media_type ENUM(
        'image',
        'video',
        'document'
    ) DEFAULT 'image',

    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
);

CREATE TABLE notifications (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    user_id CHAR(36) NOT NULL,

    title VARCHAR(255),

    message TEXT,

    is_read BOOLEAN DEFAULT FALSE,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
);

CREATE TABLE reports (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    reporter_id CHAR(36) NOT NULL,

    target_type ENUM(
        'post',
        'comment',
        'review',
        'answer'
    ) NOT NULL,

    target_id BIGINT UNSIGNED NOT NULL,

    reason TEXT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (reporter_id)
        REFERENCES users(id)
        ON DELETE CASCADE
);

CREATE TABLE bookmarks (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    user_id CHAR(36) NOT NULL,

    target_type ENUM(
        'post',
        'college',
        'event'
    ) NOT NULL,

    target_id BIGINT UNSIGNED NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    UNIQUE KEY unique_bookmark (
        user_id,
        target_type,
        target_id
    ),

    FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
);

CREATE TABLE follows (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    follower_id CHAR(36) NOT NULL,

    target_type ENUM(
        'user',
        'college',
        'club'
    ) NOT NULL,

    target_id VARCHAR(36) NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (follower_id)
        REFERENCES users(id)
        ON DELETE CASCADE
);

CREATE TABLE verification_requests (

    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    user_id CHAR(36) NOT NULL,

    college_id BIGINT UNSIGNED NOT NULL,

    student_id VARCHAR(50),

    document_url TEXT,

    type ENUM(
        'student',
        'alumni'
    ) NOT NULL,

    status ENUM(
        'pending',
        'approved',
        'rejected'
    ) DEFAULT 'pending',

    reviewed_by CHAR(36),

    reviewed_at TIMESTAMP NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE,

    FOREIGN KEY (college_id)
        REFERENCES colleges(id)
        ON DELETE CASCADE,

    FOREIGN KEY (reviewed_by)
        REFERENCES users(id)
        ON DELETE SET NULL
);