import 'package:flutter/material.dart';
import 'package:flutter_internet_speed_test/flutter_internet_speed_test.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

/// Ref: https://www.appsloveworld.com/flutter/100/40/how-can-i-convert-css-lineargradient-to-flutter-lineargradient

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    speedTest = FlutterInternetSpeedTest();
    test();
  }

  late FlutterInternetSpeedTest speedTest;

  double downloadSpeed = 0;
  String downloadUnit = "mbps";

  double uploadSpeed = 0;
  String uploadUnit = "mbps";

  bool isDownloadDone = false;
  bool isDownloadInProgress = false;
  bool isUploadInprogress = false;

  Future<void> test() async {
      isDownloadDone = false;

      await speedTest.startTesting(
          useFastApi: true,
          // downloadTestServer: "https://fast.com/",
          // uploadTestServer: "https://fast.com/",
          onStarted: () {
            print("Started Just Now");
          },
      onCompleted: (TestResult download, TestResult upload) {
            print("onCompleted ${download}");
      // TODO
      },
      onProgress: (double percent, TestResult data) {
        /// First it does the download speed transfer rate when it
        /// reaches to 100.0 percent so then it starts the upload speed transfer rate
        if(isDownloadDone){
              ///Upload
              print("onProgress: $percent");
              print("Upload Speed: ${data.transferRate} ${data.unit.name}");
              uploadUnit = data.unit.name;
              isUploadInprogress = true;

              setState(() {
                uploadSpeed = data.transferRate;
              });


            }
        else{
              ///Download
              print("onProgress: $percent");
              print("Download Speed: ${data.transferRate} ${data.unit.name}");
              downloadUnit = data.unit.name;

              isUploadInprogress = false;
              isDownloadInProgress = true;

              setState(() {
                downloadSpeed = data.transferRate;
              });

              if(percent == 100.0){
                isDownloadDone = !isDownloadDone;
              }
            }

      },
      onError: (String errorMessage, String speedTestError) {
            print("onError: ${errorMessage}");
      // TODO
      },
      onDefaultServerSelectionInProgress: () {
      // TODO
      //Only when you use useFastApi parameter as true(default)
      },
      onDefaultServerSelectionDone: (Client? client) {
      //Only when you use useFastApi parameter as true(default)
      },
      onDownloadComplete: (TestResult data) {
            print("onDownloadComplete: ${data.transferRate}");

            setState(() {
              isDownloadInProgress = false;
            });
      },
      onUploadComplete: (TestResult data) {
        print("onUploadComplete: ${data.transferRate}");

        setState(() {
          isUploadInprogress = false;
        });
      },
      onCancel: () {
      // TODO Request cancelled callback
      },
    );

      print("ONCE");
  }

  @override
  Widget build(BuildContext context) {

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-1,0),
            end: Alignment.bottomRight,
            stops: [
              0.1,
              0.3,
              0.7,
            ],
            colors: [
              Color(0xFFD3DCDC),
              Colors.deepOrange.shade200,
              Color(0xFF143131),
            ],
          ),
          // borderRadius: BorderRadius.circular(55),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Padding(padding: EdgeInsets.all(30)),

            // ElevatedButton(
            //     onPressed: (){
            //       test();
            //     },
            //     child: Text("Test"),
            // ),

            /// ConnectX
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("ConnectX", style: TextStyle(fontSize: 26),),
                Icon(LineAwesomeIcons.registered_trademark_1, size: 20,)
              ],
            ),

            Padding(padding: EdgeInsets.all(16)),

            SizedBox(
                width: width * 0.8,
                child: Text("Internet \nspeed check", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w400),)),

            Padding(padding: EdgeInsets.all(06)),

            Text("Check your upload and\ndownload speed"),

            Padding(padding: EdgeInsets.all(10)),

            /// View More
            Divider(thickness: 02, color: Colors.grey,),
            Padding(padding: EdgeInsets.all(10)),
            Row(
              children: [
                Text(" VIEW MORE", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),),
                Expanded(child: Container(),),
                Icon(LineAwesomeIcons.arrow_right)
              ],
            ),
            Padding(padding: EdgeInsets.all(10)),
            Divider(thickness: 02, color: Colors.grey,),

            Expanded(child: Container(),),

            /// Download Speed
            Row(
              children: [
                Text("Download ", style: TextStyle(fontSize: 18, color: Colors.white),),
                Icon(LineAwesomeIcons.arrow_circle_down, color: Colors.white,),
                Expanded(child: Container()),
                Text.rich(TextSpan(
                    text: '${downloadSpeed.toInt()}',
                    style: TextStyle(fontSize: 100, fontWeight: FontWeight.w500, color: Colors.white),
                    children: <InlineSpan>[
                      TextSpan(
                        text: '  mbps',
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.w400)
                      )
                    ]
                ))


              ],
            ),

            // isDownloadInProgress
            LinearProgressIndicator(
              value: isDownloadInProgress ? null : 1.0,
              minHeight: 02,
              backgroundColor: Colors.grey,
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
            /// Upload Speed
            Row(
              children: [
                Text("Upload ", style: TextStyle(fontSize: 18, color: Colors.white),),
                Icon(LineAwesomeIcons.arrow_circle_up, color: Colors.white,),
                Expanded(child: Container()),
                Text.rich(TextSpan(
                    text: '${uploadSpeed.toInt()}',
                    style: TextStyle(fontSize: 100, fontWeight: FontWeight.w500, color: Colors.white),
                    children: <InlineSpan>[
                      TextSpan(
                          text: '  $uploadUnit',
                          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w400)
                      )
                    ]
                ))


              ],
            ),

            LinearProgressIndicator(
              value: isUploadInprogress ? null : 1.0,
              minHeight: 02,
              backgroundColor: Colors.grey,
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),

            Expanded(child: Container(),)
          ],
        ),
      ),
    );
  }
}
