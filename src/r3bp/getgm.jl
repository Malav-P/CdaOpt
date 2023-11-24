function getgm(args::Int...)
    # call gm values
    gm_dict = getgm_dict()
    gm_out = []
    for naifID in args
        name = "BODY" * string(naifID) * "_GM"
        push!(gm_out, gm_dict[name])
    end
    return Tuple(gm_out)
end


function getgm_dict()
    gm_dict = Dict(
        "BODY10_GM"      => 1.3271244004193938E+11 ,  # Sun

        "BODY199_GM"     => 2.2031780000000021E+04 , # Planets, starting closest to Sun
        "BODY299_GM"     => 3.2485859200000006E+05 ,
        "BODY399_GM"     => 3.9860043543609598E+05 ,
        "BODY499_GM"     => 4.282837362069909E+04  ,
        "BODY599_GM"     => 1.266865349218008E+08  ,
        "BODY699_GM"     => 3.793120749865224E+07  ,
        "BODY799_GM"     => 5.793951322279009E+06  ,
        "BODY899_GM"     => 6.835099502439672E+06  ,
        "BODY999_GM"     => 8.696138177608748E+02  ,

        "BODY301_GM"     => 4.9028000661637961E+03 , # Moon

        "BODY401_GM"     => 7.087546066894452E-04 , # Mars' Moons
        "BODY402_GM"     => 9.615569648120313E-05 ,

        "BODY501_GM"     => 5.959916033410404E+03 , # Jupiter's Moons
        "BODY502_GM"     => 3.202738774922892E+03 ,
        "BODY503_GM"     => 9.887834453334144E+03 ,
        "BODY504_GM"     => 7.179289361397270E+03 ,
        "BODY505_GM"     => 1.378480571202615E-01 ,

        "BODY601_GM"     => 2.503522884661795E+00 , # Saturn's Moons
        "BODY602_GM"     => 7.211292085479989E+00 ,
        "BODY603_GM"     => 4.121117207701302E+01 ,
        "BODY604_GM"     => 7.311635322923193E+01 ,
        "BODY605_GM"     => 1.539422045545342E+02 ,
        "BODY606_GM"     => 8.978138845307376E+03 ,
        "BODY607_GM"     => 3.718791714191668E-01 ,
        "BODY608_GM"     => 1.205134781724041E+02 ,
        "BODY609_GM"     => 5.531110414633374E-01 ,
        "BODY610_GM"     => 1.266231296945636E-01 ,
        "BODY611_GM"     => 3.513977490568457E-02 ,
        "BODY615_GM"     => 3.759718886965353E-04 ,
        "BODY616_GM"     => 1.066368426666134E-02 ,
        "BODY617_GM"     => 9.103768311054300E-03 ,

        "BODY701_GM"     => 8.346344431770477E+01 , # Uranus' Moons
        "BODY702_GM"     => 8.509338094489388E+01 ,
        "BODY703_GM"     => 2.269437003741248E+02 ,
        "BODY704_GM"     => 2.053234302535623E+02 ,
        "BODY705_GM"     => 4.319516899232100E+00 ,

        "BODY801_GM"     => 1.427598140725034E+03 , # Neptune's Moons

        "BODY901_GM"     => 1.058799888601881E+02 , # Pluto's Moons
        "BODY902_GM"     => 3.048175648169760E-03 ,
        "BODY903_GM"     => 3.211039206155255E-03 ,
        "BODY904_GM"     => 1.110040850536676E-03 ,
    )
    return gm_dict
end