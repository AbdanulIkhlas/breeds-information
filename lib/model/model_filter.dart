class CategoryFilter {
  final List<FilteredMeals>? meals;

  CategoryFilter({
    this.meals,
  });

  CategoryFilter.fromJson(Map<String, dynamic> json)
      : meals = (json['meals'] as List?)
            ?.map((dynamic e) => FilteredMeals.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() =>
      {'meals': meals?.map((e) => e.toJson()).toList()};
}

class FilteredMeals {
  final String? strMeal;
  final String? strMealThumb;
  final String? idMeal;

  FilteredMeals({
    this.strMeal,
    this.strMealThumb,
    this.idMeal,
  });

  FilteredMeals.fromJson(Map<String, dynamic> json)
      : strMeal = json['strMeal'] as String?,
        strMealThumb = json['strMealThumb'] as String?,
        idMeal = json['idMeal'] as String?;

  Map<String, dynamic> toJson() =>
      {'strMeal': strMeal, 'strMealThumb': strMealThumb, 'idMeal': idMeal};
}
