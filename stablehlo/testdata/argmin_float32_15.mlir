// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<i32> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %0 = call @inputs() : () -> tensor<15xf32>
    %1 = call @expected() : () -> tensor<i32>
    %2 = call @argmin(%0) : (tensor<15xf32>) -> tensor<i32>
    stablehlo.custom_call @check.expect_eq(%2, %1) {has_side_effect = true} : (tensor<i32>, tensor<i32>) -> ()
    return %2 : tensor<i32>
  }
  func.func private @inputs() -> (tensor<15xf32> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<[6.35748625, 4.95101643, -3.98811984, 3.48766541, -0.183460131, -6.65203094, -3.81321788, -5.37809229, 0.617416382, 0.422738254, 5.51293945, 3.88155174, 3.41454244, -3.49898648, 2.92918921]> : tensor<15xf32>
    return %cst : tensor<15xf32>
  }
  func.func private @expected() -> (tensor<i32> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<5> : tensor<i32>
    return %c : tensor<i32>
  }
  func.func private @argmin(%arg0: tensor<15xf32>) -> tensor<i32> {
    %0 = stablehlo.iota dim = 0 : tensor<15xi32>
    %cst = stablehlo.constant dense<0x7F800000> : tensor<f32>
    %c = stablehlo.constant dense<0> : tensor<i32>
    %1:2 = stablehlo.reduce(%arg0 init: %cst), (%0 init: %c) across dimensions = [0] : (tensor<15xf32>, tensor<15xi32>, tensor<f32>, tensor<i32>) -> (tensor<f32>, tensor<i32>)
     reducer(%arg1: tensor<f32>, %arg3: tensor<f32>) (%arg2: tensor<i32>, %arg4: tensor<i32>)  {
      %2 = stablehlo.compare  LT, %arg1, %arg3,  FLOAT : (tensor<f32>, tensor<f32>) -> tensor<i1>
      %3 = stablehlo.compare  NE, %arg1, %arg1,  FLOAT : (tensor<f32>, tensor<f32>) -> tensor<i1>
      %4 = stablehlo.or %2, %3 : tensor<i1>
      %5 = stablehlo.compare  EQ, %arg1, %arg3,  FLOAT : (tensor<f32>, tensor<f32>) -> tensor<i1>
      %6 = stablehlo.compare  LT, %arg2, %arg4,  SIGNED : (tensor<i32>, tensor<i32>) -> tensor<i1>
      %7 = stablehlo.and %5, %6 : tensor<i1>
      %8 = stablehlo.or %4, %7 : tensor<i1>
      %9 = stablehlo.select %4, %arg1, %arg3 : tensor<i1>, tensor<f32>
      %10 = stablehlo.select %8, %arg2, %arg4 : tensor<i1>, tensor<i32>
      stablehlo.return %9, %10 : tensor<f32>, tensor<i32>
    }
    return %1#1 : tensor<i32>
  }
}