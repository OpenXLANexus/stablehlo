// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<20x20xf32> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %0 = call @inputs() : () -> tensor<20x20xf32>
    %1 = call @expected() : () -> tensor<20x20xf32>
    %2 = stablehlo.exponential %0 : tensor<20x20xf32>
    stablehlo.custom_call @check.expect_close(%2, %1) {has_side_effect = true} : (tensor<20x20xf32>, tensor<20x20xf32>) -> ()
    return %2 : tensor<20x20xf32>
  }
  func.func private @inputs() -> (tensor<20x20xf32> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0xB2C74AC02ABC8140DBB50E40FD0788C0028A09C0632A9E404D2E49C05441ECBF7C670CC04F93D7BF8C71C6C037D884BF00CF29BF8183AF40990E1BBEA384E9BFF06AFFC020AC8A40B04A22BF973B7340268B9EC084C4AB3E166A7B3F8731BE3F9CFA2A3FB64134406861B23F10C1C1BFAA40A8C0FE3B6E3FE4007C409D313240A75D7640659BEB3F2C13993E5C1B3FC04A09CFC00CF09EC0ED4A3DC05B74EFBD2D676BBF9E6C4B406D8B103DB61BD440C9CA6C3FEF61733FEB4A1EC0C7A81340BA45FABF7C08BA3FFEA41F3F0B5CA4BF700153C053C47A3F02DD04C087B7B1407D97F13E2D7D193F0C38D5BF099ADFC0B4333340B21E2AC046ACAFBF8FA2624050A69FBE257E70C02AC6BD409CA8B1C0114B59C02DA1B63FB696E13F5A0142C03B73F6BF40AE02BFDCDE63C0E45537BFF473DA3F6768703E54D41EC05BED4D4089800B40418576C02A17C53E30DB40405BAC99BF5761163D2916073E39B299C0C822804028BF2ABF253C75BFFFD210C0C57D2740A8FF8A3F8580BBBE5141D2C0C628604071D0C6BF3D4492C0FADA8840AEBBFEBA1E5E21C108AE0BBF1C00933FC0B404BFFE468CBF85D4A53F8F72C7BFA75F89BFD23ECABF7A7726BE40ED83C0B5A61FBF72C596BECF8D6FC0B4F81F3F37A060C0FACABAC0F795453E2EA61EBF5385373E90FC68BD0096C8BF8742E13E8C5965C0AD53A6C0C320543FF53C134020E03C40ED43533F91C8AB4087E0023F4E424ABF96D4AC40880C963F8F1CAEBE4B61BAC03B2790C0CC040A406C26E3BFA732C13F423956BF15A2CC40257038C0613838BF5A1E12C0D33F9B3FF93DFD3FEAE66B3F2A7F98C00DD66740BCB236C06A7E193E16CACE4058B96CC0FEB78ABE3C072C3E3E1EAA3FB4183E4052B07EC070FA7240C616FD3FCE27A7405B746F4010698DC0C791513F86678BC0382EE7BFFADBFEBF64BBD9C0EEB9A23ED047F4BEEC651BBF32772F40459D4EC028E756BF6C3DFF4050008C40AE36173F3EFBD3BE396EAE40815A9D3F1C0B0EC0D6A205C0E1A97D3F3B53A03F3462DD3FF53AE8BE00282B3F5611913FB00CA240F3B8CF40145FEBBF3B976440EF2CE940DA3E82BF93B04540387B8DC057E662C006E1FEBFE6A89A4039F79FBF90840240978BE03E44994540F0EE0A40BC4055C0D72E8B3F52CF22C024D7634060FE21409267563F35C508404C4AE1BF463238C0D1A585BFFCFB2040AB3F01C15FB598C02AC584C048CCD43FF782E83FA57D23BE8823B63EEB8667405EE5FDBF0EC1103F30CBBB3F2C4D774028D99CBEAF295D4065BD633F998DB6BFF66A7F4084087D40ADF24B3FF95103C05826F040721D104030A88CBF0B5774C0DF456ABF9D01EDBF6E9A0EC0EF7D92400E44F83FE4A603400821F1BF556BCE3E8FEF63BFE3B5ABBEA427B6BF45BCA1C064940DBB70D22D3F53B1B2BF0265A6409C131FC08AC1A04084C94AC0F9C8D43F0F953040993A4E3F1464963D7AB306C05EEA143F053210C0F359C5BFB817B8BFFA74E9403EA59BC0BC37203D0DF41F407BF117C01A9A42C05FF50140A240FABF3227A8C0FC5F353EF3E83D3F29BC9C406E4D77BFBBCE8740632F6940A7B80A3FBF5E8DC0B025B93F1089C83F091495BF2830943E29D4E83F8B01433F88AAAFC00FA400C002F5973F529C9A3FE62810BF4B2A16BF767BA4C0FB6E9FC02B1B19C0E1C646406CCCB5BF69110EBF95A696404D530AC0477039400A2109C03260A53FE5A106C14F9C0F407A678D3F1D94EABFD6918D40AEDBF740D7DD3F3F505DA8C0A667244025D7E5BF3ECB17C064AB4140AE13223F5F4D1F402055F63F2115B340F703A63FB98A694004E69A40393A6F3F66B0B4400B6317408B4B49BF0067EE3ECD8192BE6B9AA63F1C560A406FCB273FB55084C0212D483FC96EDBC0254312C04B073040C0A26ABF5F71CDBF51DEA2BFD5C1A4BF5A41A9BCA7166A3FEBE1703FA973A0C0A37E2940F522C83F4B07DFBEAF44E8BCF6F174BF9313BABF0F964ABF3FFA86404A9E633E6EFFB8C0D29C3640BDB2893FFE911A4040BB29C0B08D933F24C83DBFAEBA0C40327C423F5C4AE9BE021E2540B47384409FBE09BF8571D340563F7DBE07306CC0F14F563DFF6BE1BFB876983FC5DB4C3FF3D0BBBFF69065C0B178B0C080EB5A4018E2D140B4F7D9C0DDE80A40ADEFA83E4A5C9FC054F40DBFCB0CFA3DA877263F01CE873E0F6B0140FE8D63C0B47DB5BEF228FABFDB8BE6BFA0CD25BE1E29E3BFC9A1BD40"> : tensor<20x20xf32>
    return %cst : tensor<20x20xf32>
  }
  func.func private @expected() -> (tensor<20x20xf32> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0xCC502C3D828F664286C61441387A693C65C9EE3DFF240C43F3AC303D98B2213E1D55E43DE10C3E3EE6D1043BCD5BB53E46E0033F5B00714328075C3F4931253ED01BB339406C984243CE073F75E53242FC11E73BDF05B33FADE12A4079678D40409DF93F4FBF854130F080401B60613E4699AA3B714E2240092C4D424981814136DF3B4251A0C940D59AAC3F2ACB4E3D6C15CB3ADF3DE43B4BBD543D74C0633F8F22CC3E2816C0410199843F84103D44056521407D9A2540B9A7AC3D7EBC2041E5EC103ED0E18840BBCDEE3F49C78D3E7388173D2B732A405271003EEA168143292ECD3F4C21E93FE194413ED009723AAC8F8341E5858F3DFAC8813E82070A42FB6B3B3F042EBF3CF728BC43524D7E3B8D5A093D524A85407872BA4028A3453D7C51153E88A7193F15DCE83C6A2DFA3E6356B04022DFA13F9436AB3D56BFC74155800D41E2FEAD3C8C19BC3F30D9A2418A1F9A3E66C9843FDD0C923F776E063C62525B42C964033F9371C43E7818D53DE01F5B416E943D40A27F313F44A6B73AB8CA0442C4A3583E6590293C60029042C2807F3F11D22E38CC58143F38CF49408D71183F9B20AB3EB6CA69401092573EC20DAF3EDDE8523E0697593FFBB6843CB836093F3DB33E3F3C01C23CDE1BEF3F40F8F43C54273F3BF33D9B3F7DC0093FD01F993F41D8713F69A9553E1CBDC63F0E8AE33C302EB53B1A92124096AE1F412C079941E0131240CC7B5643E36BD53FEE59E83EF09D5D436EAC4E40B433363FBAA2413BE823353C67420A41669E2D3E31C39040E4BDDD3EC0AD15441481653D7650F93E44D4D03D3F3E5740E168E7409CD52040E5900B3C0FB715423BD46B3D09B3943FB41C20449AC6CA3C153E433F536A973FAAC17140BEF99B41C425993CB42F32420E22E740529A39430DA42842F059453CF71C11406E1E523CAE3C283EEAD20B3E4262913AACE3AF3FF0DD1E3F2D830B3F74337841954B223D7627DD3ECEEF3545C0E29E423111E73F3936293F04FB684392CF5A40088FDE3D5ECDFD3DB6632C4037F35F40E26BB4407CA6223F86C9F93F00C94640D83A1E4374D9244466D1223EFA4F0E426499B6442A14B93EAC9FAF4117EA443C326BEC3C67CD0B3E2E34FB42D1BA923EF7EFF5402676C63FC25FAF41D93F0C41F44D123D5EDA3D409AE3A03D56A70C425E16494146E11340AE960741EE28303E5E5F663D6739B43EE0F04541B9ACA23941A50A3C3543813C70B7A8400CCFC44024395A3FACAFB63F64FE144252E10C3E4B4FE13F1FC78A407CA33E4239733C3F936FFD418EC91B407AFC753E3C6A5842018050421AF60D40C293033ECD10E344AC131841DB9EAA3EA106B43CC309CD3E66C0203ECF9EDC3D469DC242F995DE409355FA400CA81B3EF68EBF3F562DD23EF50E373FB8C0763E5322D13B93727F3FE166FC3FA4847D3ECF3D35439D8DAA3D13F61743E54B2C3D13B3A840CC917C415B3B0F40CFC0893F1D9DF93D8D00E53F1A33D73D3B215B3E9B0B733E4C36B84455F9FC3B241B853F1EC742419EA9BE3DA5CD433D1CCCF340AAF2103E4321AB3BC1CD983FE86206406D0406430FDDC23EBE5E8B427AE71842EE0FDC3F9A99453C1EF08740A94D9940A9C19F3E19F7AA3F0C4CC5409C160940DF51873BDC33093E0DC75140FC2B5640FEC5113FBF640E3F61EEBF3B7EBBE03BC83ABB3DE6A1B241D070773E2AF8123FBA9FDD42F5DEEB3DE40691414B52F03DA0F66840EF63683906E21641242D414060D4233E0DDEA642D6741045DB6A0740CF00AA3BD6CE5041F8012A3EAA1BBF3D58EEA4415C15F13F6ACE4041C83FDB40C0B786436F216A404DC21942C015FD42F0EF22405DA78D434D602A41523AE93EFAE7CB3F884B403F44356B4080F20A415587F63FFE1C833C99E20B40CDDB893A585CD03DBF647A416DBFCC3ED1B44D3E93708F3EB7568D3EDAC37A3FF6B21F407CFE234096B1D93B9C17624190D398409699253FF3D7783F88AAC43EBA4E6F3EF60DE83E34CD8742CADC9F3FEA2E4A3B2CC38A41D8A93B40AA1033419665903DEBAE4A40D6F4F33E983D104146CF08405A50223F21255341C6FD7A42F778153F5A2D3944DFE8473F807BCC3C25E0863F92FA2F3E0E9C524098770E40B1136C3E5FC5E23CF3F4833B3AB5F441685D30444051903A8A320C412109B23FE83EE13BDD08133F4A9F903FF940F53F3BE1A63F73BFF1400A03EA3C4098333F7F0D113E9C12293E21BB593FBE9A2D3E8853BB43"> : tensor<20x20xf32>
    return %cst : tensor<20x20xf32>
  }
}