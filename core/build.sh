#!/bin/bash

set -e

export OPTIMIZE="-Os"
export LDFLAGS="${OPTIMIZE} Wall -DNDEBUG -march=native -ffast-math -std=c++11 -O3 -fPIC"
export CFLAGS="${OPTIMIZE}"
export CXXFLAGS="${OPTIMIZE}"

echo "============================================="
echo "Compiling routing-kit"
echo "============================================="
(
    cd ./routing-kit
    rm -rf build
    mkdir -p build
    emcc -Iinclude \
        ${OPTIMIZE} \
        --no-entry \
        -s ERROR_ON_UNDEFINED_SYMBOLS=0 \
        -s STRICT=1 \
        -s ALLOW_MEMORY_GROWTH=1 \
        -s ASSERTIONS=0 \
        -s MALLOC=emmalloc \
        -s MODULARIZE=1 \
        -o ./build/routing-kit.o \
        ./src/timer.cpp \
        ./src/graph_util.cpp \
        ./src/bit_select.cpp \
        ./src/id_mapper.cpp \
        ./src/vector_io.cpp \
        ./src/expect.cpp \
        ./src/contraction_hierarchy.cpp \
        ./src/bit_vector.cpp \
        ./src/customizable_contraction_hierarchy.cpp \
        ./src/nested_dissection.cpp \


        # build/timer.o \
        # build/compute_contraction_hierarchy.o \
        # build/strongly_connected_component.o \
        # build/encode_vector.o \
        # build/compare_vector.o \
        # build/show_path.o \
        # build/convert_road_dimacs_coordinates.o \
        # build/graph_util.o \
        # build/generate_random_node_list.o \
        # build/geo_position_to_node.o \
        # build/verify.o \
        # build/bit_select.o \
        # build/id_mapper.o \
        # build/nested_dissection.o \
        # build/export_road_dimacs_graph.o \
        # build/vector_io.o \
        # build/expect.o \
        # build/compute_nested_dissection_order.o \
        # build/protobuf.o \
        # build/randomly_permute_nodes.o \
        # build/graph_to_svg.o \
        # build/contraction_hierarchy.o \
        # build/buffered_asynchronous_reader.o \
        # build/decode_vector.o \
        # build/convert_road_dimacs_graph.o \
        # build/bit_vector.o \
        # build/run_dijkstra.o \
        # build/generate_constant_vector.o \
        # build/generate_random_source_times.o \
        # build/customizable_contraction_hierarchy.o \
        # build/examine_ch.o \
        # build/compute_geographic_distance_weights.o \
        # build/graph_to_dot.o \
        # build/run_contraction_hierarchy_query.o \
        # build/file_data_source.o 
    cd ..
)
echo "============================================="
echo "Compiling routing-kit done"
echo "============================================="

echo "============================================="
echo "Compiling wasm bindings"
echo "============================================="
(
    # Compile C/C++ code
    emcc \
    ${OPTIMIZE} \
    --bind \
    --no-entry \
    -s ERROR_ON_UNDEFINED_SYMBOLS=0 \
    -s STRICT=1 \
    -s ALLOW_MEMORY_GROWTH=1 \
    -s ASSERTIONS=0 \
    -s MALLOC=emmalloc \
    -s MODULARIZE=1 \
    -s EXPORT_ES6=1 \
    -o ./module.js \
    -I ./routing-kit/include \
    module.cpp \
    ./routing-kit/build/routing-kit.o
    # ./routing-kit/build/timer.o \
    # ./routing-kit/build/graph_util.o \
    # ./routing-kit/build/bit_select.o \
    # ./routing-kit/build/id_mapper.o \
    # ./routing-kit/build/vector_io.o \
    # ./routing-kit/build/expect.o \
    # ./routing-kit/build/contraction_hierarchy.o \
    # ./routing-kit/build/bit_vector.o \
    # ./routing-kit/build/customizable_contraction_hierarchy.o
    
    # ./routing-kit/src/nested_dissection.cpp \
    # ./routing-kit/src/verify.cpp \
    # ./routing-kit/src/buffered_asynchronous_reader.cpp \
    # ./routing-kit/src/compute_geographic_distance_weights.cpp
    # ./routing-kit/src/decode_vector.cpp \
    # ./routing-kit/src/compute_nested_dissection_order.cpp \
    # ./routing-kit/src/compute_contraction_hierarchy.cpp \
    # ./routing-kit/src/strongly_connected_component.cpp \
    # ./routing-kit/src/encode_vector.cpp \
    # ./routing-kit/src/compare_vector.cpp \
    # ./routing-kit/src/show_path.cpp \
    # ./routing-kit/src/convert_road_dimacs_coordinates.cpp \
    # ./routing-kit/src/generate_random_node_list.cpp \
    # ./routing-kit/src/geo_position_to_node.cpp \
    # ./routing-kit/src/export_road_dimacs_graph.cpp \
    # ./routing-kit/src/protobuf.cpp \
    # ./routing-kit/src/randomly_permute_nodes.cpp \
    # ./routing-kit/src/graph_to_svg.cpp \
    # ./routing-kit/src/convert_road_dimacs_graph.cpp \
    # ./routing-kit/src/run_dijkstra.cpp \
    # ./routing-kit/src/generate_constant_vector.cpp \
    # ./routing-kit/src/generate_random_source_times.cpp \
    # ./routing-kit/src/examine_ch.cpp \
    # ./routing-kit/src/graph_to_dot.cpp \
    # ./routing-kit/src/run_contraction_hierarchy_query.cpp \
    # ./routing-kit/src/file_data_source.cpp
)