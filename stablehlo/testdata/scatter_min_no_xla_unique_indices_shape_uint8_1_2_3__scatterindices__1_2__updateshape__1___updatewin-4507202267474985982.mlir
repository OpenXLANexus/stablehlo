// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[1, 2]> : tensor<2xi32>
    %1:2 = call @inputs() : () -> (tensor<1x2x3xui8>, tensor<1xui8>)
    %2 = call @expected() : () -> tensor<1x2x3xui8>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<ui8>, %arg1: tensor<ui8>):
      %5 = stablehlo.minimum %arg0, %arg1 : tensor<ui8>
      stablehlo.return %5 : tensor<ui8>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1, 2], scatter_dims_to_operand_dims = [1, 2]>, unique_indices = true} : (tensor<1x2x3xui8>, tensor<2xi32>, tensor<1xui8>) -> tensor<1x2x3xui8>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<1x2x3xui8>, tensor<1x2x3xui8>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<1x2x3xui8>, tensor<1xui8>) {
    %0 = stablehlo.constant dense<[[[7, 2, 5], [0, 1, 3]]]> : tensor<1x2x3xui8>
    %1 = stablehlo.constant dense<2> : tensor<1xui8>
    return %0, %1 : tensor<1x2x3xui8>, tensor<1xui8>
  }
  func.func private @expected() -> tensor<1x2x3xui8> {
    %0 = stablehlo.constant dense<[[[7, 2, 5], [0, 1, 2]]]> : tensor<1x2x3xui8>
    return %0 : tensor<1x2x3xui8>
  }
}
