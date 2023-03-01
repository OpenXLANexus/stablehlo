// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<0> : tensor<1xi32>
    %1:2 = call @inputs() : () -> (tensor<1x125xi32>, tensor<1xi32>)
    %2 = call @expected() : () -> tensor<1x125xi32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<i32>, %arg1: tensor<i32>):
      %5 = stablehlo.maximum %arg0, %arg1 : tensor<i32>
      stablehlo.return %5 : tensor<i32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1]>, unique_indices = true} : (tensor<1x125xi32>, tensor<1xi32>, tensor<1xi32>) -> tensor<1x125xi32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<1x125xi32>, tensor<1x125xi32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<1x125xi32>, tensor<1xi32>) {
    %0 = stablehlo.constant dense<"0x0200000005000000FEFFFFFFFAFFFFFF0000000000000000FCFFFFFF0000000000000000010000000000000006000000FFFFFFFF00000000FEFFFFFF02000000FFFFFFFF00000000FEFFFFFF01000000FEFFFFFF0100000000000000FEFFFFFFFFFFFFFF050000000300000001000000FEFFFFFF0000000000000000020000000300000003000000000000000100000002000000040000000300000001000000010000000000000003000000000000000000000003000000F9FFFFFFFCFFFFFF020000000200000002000000FEFFFFFFFEFFFFFFFEFFFFFF01000000FFFFFFFFFFFFFFFF0000000000000000000000000000000003000000F9FFFFFFFCFFFFFFFEFFFFFFFFFFFFFFFCFFFFFF000000000200000001000000FFFFFFFF0000000002000000FEFFFFFF0100000001000000FEFFFFFF010000000100000000000000FEFFFFFF0100000003000000020000000000000002000000FFFFFFFF02000000FFFFFFFF00000000FCFFFFFF0100000000000000000000000600000001000000FBFFFFFF00000000020000000200000000000000FDFFFFFFFEFFFFFFF9FFFFFF0000000000000000000000000000000000000000FEFFFFFF03000000FEFFFFFF0300000001000000020000000000000005000000020000000300000000000000FFFFFFFFFFFFFFFF030000000100000003000000"> : tensor<1x125xi32>
    %1 = stablehlo.constant dense<-3> : tensor<1xi32>
    return %0, %1 : tensor<1x125xi32>, tensor<1xi32>
  }
  func.func private @expected() -> tensor<1x125xi32> {
    %0 = stablehlo.constant dense<"0x0200000005000000FEFFFFFFFAFFFFFF0000000000000000FCFFFFFF0000000000000000010000000000000006000000FFFFFFFF00000000FEFFFFFF02000000FFFFFFFF00000000FEFFFFFF01000000FEFFFFFF0100000000000000FEFFFFFFFFFFFFFF050000000300000001000000FEFFFFFF0000000000000000020000000300000003000000000000000100000002000000040000000300000001000000010000000000000003000000000000000000000003000000F9FFFFFFFCFFFFFF020000000200000002000000FEFFFFFFFEFFFFFFFEFFFFFF01000000FFFFFFFFFFFFFFFF0000000000000000000000000000000003000000F9FFFFFFFCFFFFFFFEFFFFFFFFFFFFFFFCFFFFFF000000000200000001000000FFFFFFFF0000000002000000FEFFFFFF0100000001000000FEFFFFFF010000000100000000000000FEFFFFFF0100000003000000020000000000000002000000FFFFFFFF02000000FFFFFFFF00000000FCFFFFFF0100000000000000000000000600000001000000FBFFFFFF00000000020000000200000000000000FDFFFFFFFEFFFFFFF9FFFFFF0000000000000000000000000000000000000000FEFFFFFF03000000FEFFFFFF0300000001000000020000000000000005000000020000000300000000000000FFFFFFFFFFFFFFFF030000000100000003000000"> : tensor<1x125xi32>
    return %0 : tensor<1x125xi32>
  }
}
