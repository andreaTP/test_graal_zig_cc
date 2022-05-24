# Build

Build fully static binaries with `zig cc`:

```bash
docker build . -t graal_zigcc --progress=plain
```

# Run

```bash
docker run --rm -it graal_zigcc
```

## Not working ATM

Cross-compile Mac binaries:

```bash
docker build -f Dockerfile.mac . -t graal_zigcc_mac --progress=plain
```

Cross-compile Windows binaries:

```bash
docker build -f Dockerfile.win . -t graal_zigcc_win --progress=plain
```

Error:
```
#18 7.680 Error: Missing CAP cache value for: NativeCodeInfo:AMD64LibCHelperDirectives:StructInfo:CPUFeatures
#18 7.680 com.oracle.svm.core.util.UserError$UserException: Missing CAP cache value for: NativeCodeInfo:AMD64LibCHelperDirectives:StructInfo:CPUFeatures
#18 7.681       at com.oracle.svm.core.util.UserError.abort(UserError.java:72)
#18 7.681       at com.oracle.svm.hosted.c.info.InfoTreeVisitor.processChildren(InfoTreeVisitor.java:66)
#18 7.681       at com.oracle.svm.hosted.c.info.InfoTreeVisitor.visitNativeCodeInfo(InfoTreeVisitor.java:72)
#18 7.681       at com.oracle.svm.hosted.c.info.NativeCodeInfo.accept(NativeCodeInfo.java:57)
#18 7.681       at com.oracle.svm.hosted.c.query.QueryResultParser.parse(QueryResultParser.java:79)
#18 7.681       at com.oracle.svm.hosted.c.CAnnotationProcessor.makeQuery(CAnnotationProcessor.java:134)
#18 7.681       at com.oracle.svm.hosted.c.CAnnotationProcessor.process(CAnnotationProcessor.java:117)
#18 7.681       at com.oracle.svm.hosted.c.NativeLibraries.finish(NativeLibraries.java:554)
#18 7.681       at com.oracle.svm.hosted.NativeImageGenerator.processNativeLibraryImports(NativeImageGenerator.java:1622)
#18 7.681       at com.oracle.svm.hosted.NativeImageGenerator.setupNativeLibraries(NativeImageGenerator.java:1065)
#18 7.681       at com.oracle.svm.hosted.NativeImageGenerator.setupNativeImage(NativeImageGenerator.java:888)
#18 7.681       at com.oracle.svm.hosted.NativeImageGenerator.doRun(NativeImageGenerator.java:555)
#18 7.682       at com.oracle.svm.hosted.NativeImageGenerator.run(NativeImageGenerator.java:515)
#18 7.682       at com.oracle.svm.hosted.NativeImageGeneratorRunner.buildImage(NativeImageGeneratorRunner.java:407)
#18 7.682       at com.oracle.svm.hosted.NativeImageGeneratorRunner.build(NativeImageGeneratorRunner.java:585)
#18 7.682       at com.oracle.svm.hosted.NativeImageGeneratorRunner.main(NativeImageGeneratorRunner.java:128)
#18 7.682       at com.oracle.svm.hosted.NativeImageGeneratorRunner$JDK9Plus.main(NativeImageGeneratorRunner.java:615)
#18 7.682 ------------------------------------------------------------------------------------------------------------------------
#18 7.690                          0.3s (4.1% of total time) in 6 GCs | Peak RSS: 0.51GB | CPU load: 3.11
#18 7.691 ========================================================================================================================
#18 7.691 Failed generating 'code-with-quarkus-1.0.0-SNAPSHOT-runner' after 5.2s.
#18 7.769 Error: Image build request failed with exit status 1
#18 7.769 com.oracle.svm.driver.NativeImage$NativeImageError: Image build request failed with exit status 1
#18 7.769       at com.oracle.svm.driver.NativeImage.showError(NativeImage.java:1678)
#18 7.769       at com.oracle.svm.driver.NativeImage.build(NativeImage.java:1389)
#18 7.769       at com.oracle.svm.driver.NativeImage.performBuild(NativeImage.java:1350)
#18 7.769       at com.oracle.svm.driver.NativeImage.main(NativeImage.java:1337)
```
