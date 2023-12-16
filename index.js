import module from "./core/module.js";
const nodes = (await import("./data/node.json", { assert: { type: "json" } }))
  .default;
const edges = (
  await import("./data/connections.json", {
    assert: { type: "json" },
  })
).default;

const instance = await module();

console.time("cch");

const lat = instance["newVectorFloat"]();
const lon = instance["newVectorFloat"]();

nodes.forEach((node, i) => {
  lat.push_back(-node.y);
  lon.push_back(node.x);
});

const idMap = new Map(nodes.map((node, i) => [node.id, i]));
const nodeMap = new Map(nodes.map((node) => [node.id, node]));

const tail = instance["newVectorUInt"]();
const head = instance["newVectorUInt"]();

edges.forEach((edge) => {
  tail.push_back(idMap.get(edge.nodeIdFrom));
  head.push_back(idMap.get(edge.nodeIdTo));
});

const node_order = instance["get_node_order"](
  nodes.length,
  tail,
  head,
  lat,
  lon
);

const cch = new instance.CCH(node_order, tail, head);
console.timeEnd("cch");

console.time("metric");
const weights = instance["newVectorUInt"]();

edges.forEach(({ nodeIdFrom, nodeIdTo }) => {
  const from = nodeMap.get(nodeIdFrom);
  const to = nodeMap.get(nodeIdTo);

  const dx = from.x - to.x;
  const dy = from.y - to.y;

  const length = Math.sqrt(dx * dx + dy * dy);

  const level =
    from.floorPlanId === to.floorPlanId ||
    (from.nodeTypeId === 7 && to.nodeTypeId === 7)
      ? 0
      : 5;

  const total = level + (Math.round(length * 0.063) || 1);

  weights.push_back(Math.round(total));
});

const metric = new instance["create_matric"](cch, weights);
metric.customize();
console.timeEnd("metric");

console.time("query");
const query = instance["create_query"](metric);
query.reset();

query.add_source(idMap.get(178), 0);

query.add_target(idMap.get(636), 0);

query.run();

const npath = query.get_node_path();

const nids = [];
for (let i = 0; i < npath.size(); i++) {
  nids.push(nodes[npath.get(i)].id);
}

const epath = query.get_arc_path();
const eids = [];
for (let i = 0; i < epath.size(); i++) {
  eids.push(edges[epath.get(i)].id);
}

console.log(nids);
console.log(eids);

console.timeEnd("query");
