
class BaseUrlGenerator {

  static String BASE_URL_KEY =  "http://192.168.254.115";
  static String BASE_URL_PORT = "5000";

  // BOOKS API
  static String GET_BOOK_API = "${BASE_URL_KEY}:${BASE_URL_PORT}/getBooks";
  static String RESERVE_BOOK_API = "${BASE_URL_KEY}:${BASE_URL_PORT}/reserve";
  static String GET_RESERVED_BOOKS_API = "${BASE_URL_KEY}:${BASE_URL_PORT}/getReserve";
  static String GET_BOOK_THUMBNAIL = "${BASE_URL_KEY}:${BASE_URL_PORT}/temp";
  static String GET_BOOK_ITEM = "${BASE_URL_KEY}:${BASE_URL_PORT}/getBookItems";
  static String SEARCH_BOOKS = "${BASE_URL_KEY}:${BASE_URL_PORT}/searchBooks";

  // QUOTES API
  static String GET_QUOTES_API = "${BASE_URL_KEY}:${BASE_URL_PORT}/getQuotes";

  // LOGIN API
  static String SUBMIT_LOGIN_API = "${BASE_URL_KEY}:${BASE_URL_PORT}/auth";

}