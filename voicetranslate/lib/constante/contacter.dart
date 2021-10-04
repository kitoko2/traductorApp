import "package:url_launcher/url_launcher.dart";

contactNumberWhatsApp() async {
  var url = "https://wa.me/2250787610716?text=Bonjour Mr";
  await canLaunch(url) ? launch(url) : throw "error";
}

contactMail() async {
  var url = "mailto:Dogbo804@gmail.com";
  await canLaunch(url) ? launch(url) : throw "error";
}
