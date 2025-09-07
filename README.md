# Narratree

![index_screenshot](screenshots/Index_Screenshot.png)

![article_screenshot](screenshots/Article_Screenshot.png)

## Description

Narratree is a simple blogging platform built with Ruby on Rails. Users can create articles and leave comments. This project is part of The Odin Project curriculum.

## Features

- Create, edit, and delete articles
- Add and delete comments on articles
- Responsive and modern UI
- Validations to prevent blank submissions
- Like articles and comments
- Save articles to your saved articles list

## Getting Started

### Prerequisites

- Ruby 3.x
- Rails 7.x
- SQLite3 (default) or another supported database

### Setup

1. Clone the repository:
   ```sh
   git clone https://github.com/atshaw1994/Narratree.git
   cd Narratree
   ```
2. Install dependencies:
   ```sh
   bundle install
   ```
3. Set up the database:
   ```sh
   bin/rails db:setup
   ```
4. Start the server:
   ```sh
   bin/rails server
   ```
5. Visit `http://localhost:3000` in your browser.

## Usage

- Create a new article from the homepage.
- Add comments to articles.
- Delete comments and articles as needed.

## Contributing

Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

## License

This project is licensed under the MIT License.
