import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import './computer.dart';

class WebScraper {
  final String url =
      "https://www.newegg.com/Desktop-Computers/SubCategory/ID-10?Tid=19096";

  Future<List<Computer>> extractData() async {
    http.Response response = await http.get(Uri.parse(url));
    List<Computer> computers = [];
    if (response.statusCode == 200) {
      final html = parser.parse(response.body);

      final container = html.querySelector(".item-cells-wrap")!.children;

      container.forEach((element) {
        try {
          final div = element.getElementsByClassName("item-container")[0];

          final image = div.querySelector("a img")!.attributes["src"];
          String info = div.querySelector(".item-info .item-title")!.text;
          String price =
              div.querySelector(".item-action .price .price-current")!.text;

          computers.add(Computer(image: image!, info: info, price: price));
        } catch (e) {
          print(e);
        }
      });
    }

    return computers;
  }
}
