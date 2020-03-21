import 'dart:convert';

import 'package:http/http.dart' as http;

List<Statistics> statistics = List();

fetchStats() async {
  print('fetching');
  final response =
      await http.get("https://pomber.github.io/covid19/timeseries.json");
  print('fetched');
  Map decodedJson = json.decode(response.body);
  decodedJson.forEach((k, v) {
    String country = k;
    String date = v[v.length - 1]['date'];
    String confirmed = v[v.length - 1]['confirmed'].toString();
    String deaths = v[v.length - 1]['deaths'].toString();
    String recovered = v[v.length - 1]['recovered'].toString();
    statistics.add(
        Statistics.createObject(country, confirmed, deaths, date, recovered));
  });
  statistics.sort((a,b)=>a.country.compareTo(b.country));
  return statistics;
}

class Statistics {
  final country;
  final confirmed;
  final deaths;
  final recovered;
  final date;

  Statistics(
      {this.country, this.confirmed, this.deaths, this.date, this.recovered});

  factory Statistics.createObject(
      String cntry, String cnfrmd, String dths, String dt, String rcvrd) {
    print('called');
    return Statistics(
        country: cntry,
        confirmed: cnfrmd,
        deaths: dths,
        date: dt,
        recovered: rcvrd);
  }
}
