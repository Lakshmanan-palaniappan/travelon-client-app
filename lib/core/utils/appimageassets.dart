/// Centralized asset paths to use across the application
/// Provides asset constants for:
///     - Lottie animations
///     - SVG files

class AppImageAssets {
  final String basepath = "assets/images/";

  // ================= LOTTIE ANIMATIONS =================
  late final String travel_lottie =
      "${basepath}lottieanimations/WorldTravelLoader.json";

  late final String worldmap_lottie =
      "${basepath}lottieanimations/World_map.json";
  late final String planning_man_lottie =
      "${basepath}lottieanimations/Man_planning.json";
  late final String register_lottie =
      "${basepath}lottieanimations/Register.json";
  late final String login_lottie = "${basepath}lottieanimations/Login.json";
  late final String travelon_lottie =
      "${basepath}lottieanimations/travelon.json";

// ================= SVG FILES =================
// svg image for replacing custom clipper
  late final String blob_svg = "${basepath}svgfiles/blob.svg";
  late final String blob2_svg = "${basepath}svgfiles/blob2.svg";
  late final String blob3_svg = "${basepath}svgfiles/blob3.svg";

  late final String man_svg = "${basepath}svgfiles/man.svg";
}
