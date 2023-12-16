#include <routingkit/customizable_contraction_hierarchy.h>
#include <routingkit/nested_dissection.h>
#include <emscripten/bind.h>

using namespace emscripten;
using namespace RoutingKit;

std::vector<unsigned> newVectorUInt()
{
  std::vector<unsigned> v(10, 1);
  return v;
}

std::vector<float> newVectorFloat()
{
  std::vector<float> v(10, 1);
  return v;
}

std::vector<unsigned> get_node_order(
    unsigned node_count,
    const std::vector<unsigned> &tail,
    const std::vector<unsigned> &head,
    const std::vector<float> &lat,
    const std::vector<float> &lon)
{
  return compute_nested_node_dissection_order_using_inertial_flow(
      node_count, tail, head, lat, lon);
}

CustomizableContractionHierarchyMetric create_matric(
    const CustomizableContractionHierarchy &cch,
    const std::vector<unsigned> &weight)
{
  return CustomizableContractionHierarchyMetric(cch, weight);
}

CustomizableContractionHierarchyQuery create_query(
    const CustomizableContractionHierarchyMetric &metric)
{
  return CustomizableContractionHierarchyQuery(metric);
}

EMSCRIPTEN_BINDINGS(my_module)
{
  function("newVectorUInt", &newVectorUInt);
  register_vector<unsigned>("VectorUInt");

  function("newVectorFloat", &newVectorFloat);
  register_vector<float>("VectorFloat");

  function("get_node_order", &get_node_order);

  function("create_matric", &create_matric);
  function("create_query", &create_query);

  class_<CustomizableContractionHierarchy>("CCH")
      .constructor<std::vector<unsigned>, std::vector<unsigned>, std::vector<unsigned>>();

  class_<CustomizableContractionHierarchyMetric>("CCHMetric")
      .function("reset",
                select_overload<CustomizableContractionHierarchyMetric &(const CustomizableContractionHierarchy &, const std::vector<unsigned> &)>(&CustomizableContractionHierarchyMetric::reset))
      .function("customize", &CustomizableContractionHierarchyMetric::customize);

  class_<CustomizableContractionHierarchyQuery>("CCHQuery")
      .function("reset", select_overload<CustomizableContractionHierarchyQuery &()>(
                             &CustomizableContractionHierarchyQuery::reset))
      .function("add_source", &CustomizableContractionHierarchyQuery::add_source)
      .function("add_target", &CustomizableContractionHierarchyQuery::add_target)
      .function("run", &CustomizableContractionHierarchyQuery::run)
      .function("get_node_path", &CustomizableContractionHierarchyQuery::get_node_path)
      .function("get_arc_path", &CustomizableContractionHierarchyQuery::get_arc_path);
}

// CustomizableContractionHierarchy(
//     std::vector<unsigned> order, std::vector<unsigned> tail, std::vector<unsigned> head, std::function<void(const std::string &)> log_message = [](const std::string &) {}, bool filter_always_inf_arcs = false);
