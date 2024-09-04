// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<20x20xui16> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %0:2 = call @inputs() : () -> (tensor<20x20xui16>, tensor<20x20xui16>)
    %1 = call @expected() : () -> tensor<20x20xui16>
    %2 = stablehlo.add %0#0, %0#1 : tensor<20x20xui16>
    stablehlo.custom_call @check.expect_eq(%2, %1) {has_side_effect = true} : (tensor<20x20xui16>, tensor<20x20xui16>) -> ()
    return %2 : tensor<20x20xui16>
  }
  func.func private @inputs() -> (tensor<20x20xui16> {mhlo.layout_mode = "default"}, tensor<20x20xui16> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<"0x040000000000030000000200030001000100000004000000000000000500030005000200020000000200030000000200030000000100000000000100010000000100010000000000050004000200010006000000020000000100020006000100000004000300000000000000000002000100000003000300030001000100050001000000060004000000010003000100000000000300060000000200040004000000020000000200020000000900060002000200020003000000050004000300050005000500050001000300050004000200020005000000000003000100030004000500000008000000000002000000010000000500030006000000020001000400020002000300010001000200020001000600050002000300020007000000000002000200000006000100000002000000020000000000040000000200040000000200000000000100000000000400020001000000010005000200000001000000000000000200040005000000000001000400000001000400040004000300010000000100000003000300000003000A000100010000000100020000000300000003000300060000000000030001000100010000000200090005000400010000000200000002000100000001000000010007000300030001000100010001000300010001000000010001000000020000000200010000000400040003000000000002000200000002000300040000000200010000000300010000000300000005000100010001000600050001000100040003000300030001000100030001000200020001000400010001000000060005000300020000000000020003000200010001000000000001000000010001000100010003000500030003000300000003000100000000000700010000000000010001000000000005000000010003000100040003000100020000000400020004000000000001000100030004000000030004000300010003000000010001000000040006000000030004000000010000000400040001000000020006000300010000000100010000000100010001000100020001000200020003000100000000000000050004000200040000000200"> : tensor<20x20xui16>
    %c_0 = stablehlo.constant dense<"0x0100000000000000040003000100020003000400000003000300030000000100010001000100020002000500010000000000030000000200000002000100020000000100020005000300010005000000020004000200020001000100010001000200020001000100020003000100000004000300040005000000020000000000010000000200000002000200020003000300030000000400000000000100010001000300010002000000020002000000010000000100040003000200040002000400010007000300040001000900020002000300010004000800010004000300000001000000020002000400020000000600080004000100010005000300050001000300040000000100040000000100000005000000010000000200030006000000000004000200010001000200000000000200010001000300010005000100050001000300020003000000020003000100040004000300000003000100020002000600040005000300000000000000000002000100020000000000020000000300030000000100020000000800000006000200020001000000070000000200000005000400000001000200060000000300030002000000000000000000040001000000010001000400000000000000020000000300030002000400000005000200010000000100000003000000030000000400060001000300070004000400000002000300010004000600010000000500030000000400020004000300010005000100010000000400030002000400050001000200030003000100010000000000050000000000030001000500000003000600000001000500010002000200010002000100030005000000020003000600000002000000000000000000010002000300000003000000060004000500010002000100030006000400000007000200020000000200040003000000000004000600010001000000020000000000030000000000000001000200040001000100010001000200010002000300020004000000000002000000020000000000020001000400020000000000020004000700000000000100010000000100020000000200040007000600010001000100"> : tensor<20x20xui16>
    return %c, %c_0 : tensor<20x20xui16>, tensor<20x20xui16>
  }
  func.func private @expected() -> (tensor<20x20xui16> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<"0x0500000000000300040005000400030004000400040003000300030005000400060003000300020004000800010002000300030001000200000003000200020001000200020005000800050007000100080004000400020002000300070002000200060004000100020003000100020005000300070008000300030001000500020000000800040002000300050004000300030003000A0000000200050005000100050001000400020002000B00060003000200030007000300070008000500090006000C000800050004000E000600040005000600040008000400050006000400060000000A000200040004000000070008000900040007000500050006000500050006000300020005000200030001000B0005000300030004000A00060000000200060002000700020002000200000004000100010007000100070005000500030003000200040000000200070003000500040004000500050001000300020006000400070007000500000000000100060001000300040004000600030004000300010001000500030008000300100003000300010001000900000005000000080007000600010002000900010004000400020002000900050004000500010002000100030005000000010000000300070006000600030005000100060005000200010001000100040000000500000006000700010007000B000700040000000400050001000600090005000000070004000000070003000400060001000A000200020001000A0008000300050009000400050006000400020004000100020007000100040004000200050006000800090002000100050003000500040002000300010003000600000003000400070001000500050003000300030001000500040000000300070007000400050002000300010003000B00040001000A00030006000300030006000300040002000800060001000200010005000400000006000400030001000400020005000200010005000700020004000600030003000400040004000300000004000600030003000100050003000000010003000500080002000100030003000300020002000000020009000B000800050001000300"> : tensor<20x20xui16>
    return %c : tensor<20x20xui16>
  }
}