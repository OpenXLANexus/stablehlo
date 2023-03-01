// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_fun_flat_jax {
  func.func public @main(%arg0: tensor<i64>, %arg1: tensor<?x7x3x4xf32> {mhlo.sharding = ""}, %arg2: tensor<?x7x4xf32> {mhlo.sharding = ""}) -> tensor<?x7x3xf32> {
    %0 = "stablehlo.dot_general"(%arg1, %arg2) {dot_dimension_numbers = #stablehlo.dot<lhs_batching_dimensions = [0, 1], rhs_batching_dimensions = [0, 1], lhs_contracting_dimensions = [3], rhs_contracting_dimensions = [2]>} : (tensor<?x7x3x4xf32>, tensor<?x7x4xf32>) -> tensor<?x7x3xf32>
    return %0 : tensor<?x7x3xf32>
  }
}
