import 'package:sqlite3/sqlite3.dart';

class DatabaseHelper {

  final db = sqlite3.openInMemory();

  void printVersion() {
    print('Using sqlite3 ${sqlite3.version}');
  }

  void addUsersTable() {
    db.execute('''
        CREATE TABLE users (
          id INT PRIMARY KEY AUTO_INCREMENT,
          name VARCHAR(50) NOT NULL,
          username VARCHAR(50) UNIQUE NOT NULL,
          phoneNumber VARCHAR(50) UNIQUE NOT NULL,
          email VARCHAR(50) NOT NULL,
          password VARCHAR(100) NOT NULL
        );
    ''');
  }

  void addMessagesTable() {
    db.execute('''
        CREATE TABLE messages (
          id INT PRIMARY KEY AUTO_INCREMENT,
          message VARCHAR(1500) NOT NULL,
          sender_id INT,
          receiver_id INT,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
          FOREIGN KEY (sender_id) REFERENCES USERS(id),
          FOREIGN KEY (receiver_id) REFERENCES USERS(id)
        );
    ''');
  }

  void insertUser(String name, String username, String phoneNumber, String email, String password) {
    final stmt = db.prepare('INSERT INTO users (name, username, phoneNumber, email, password) VALUES (?, ?, ?, ?, ?)');
    stmt.execute([name, username, phoneNumber, email, password]);
    stmt.dispose();
  }

  void selectUsersByUsername(String username) {
    // You can run select statements with PreparedStatement.select, or directly
    // on the database:
    final ResultSet resultSet =
    db.select('SELECT * FROM users WHERE username = ?', [username]);

    // You can iterate on the result set in multiple ways to retrieve Row objects
    // one by one.
    for (final Row row in resultSet) {
      print('User[name: ${row['name']}, username: ${row['username']}]');
    }
  }

  void disposeTheDB() {
    db.dispose();
  }

}
