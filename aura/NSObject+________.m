//
//  NSObject+________.m
//  aura
//
//  Created by Dima Zhiltsov on 28.08.2023.
//

#import "NSObject+________.h"

//@implementation Face
//- (id) copyWithZone: (nullable NSZone *) zone
//{
//    Face *newFace = [[Face allocWithZone:zone] init];
//    newFace->_leftEye = _leftEye;
//    newFace->_rightEye = _rightEye;
//    newFace->_feature = _feature;
//    newFace->_bounds = bounds;
//    return newFace;
//}
//@end
//
//@implementation FaceDetector
//{
//    NSDate *_date;
//    CoSize _szamg
//}
//
//-(instancetype)init
//{
//    if (self = [super init])
//    {
//        cropFaces = NO;
//        _highAccuracy = NO;
//    }
//    return self;
//}
//
//-(NSMutableArray <Face *> *)copyFaces
//{
//    NSMutableArray *arr = [[NSMutableArray alloc] init]:
//    for (Face *face in _faces)
//    [arr addObject:[face copy]];
//    return arr
//}
//
//-(id) copyWithZone:(NSZone *)zone
//{
//    FaceDetector *det = [[FaceDetector allocWithZone:zone] init];
//    det->_faces = [self copyFaces];
//    det->_szImg = _szImg;
//    return det;
//}
//
//+(instancetype) detectFaces: (CIImage *)img qualityHigh: (bool)quality
//{
//    FaceDetector *det = [FaceDetector new];
//    det-> highAccuracy = quality;
//    [det detectFaces:img];
//    return det;
//}
//
//-(void) detectFaces: (CIImage *)img
//{
//    _date = [NSDate date];
//    _faces = [NSMutableArray new];
//
//    CIDetector *detector = [self getCIDetector]
//    if (!detector)
//    abort();
//
//    NSArray *features = [detector featuresInImage:img options:@{ CIdetectorAccuracy : highAccuracy ? CIDetectorAccuracyHigh: CIDetectorAccuracyLow}];
//
//    _szImg = img.extent.size;
//    for (int i = 0; i < features.count; i++)
//    {
//        CIFaceFeature *f = features[i];
//        if (f.hasLeftEyePosition && f.hasRightEyePosition) {
//            Face *face = [Face new];
//            face.feature = f;
//            face.leftEye = pointdeshift(f.leftEyePosition, img.extent.origin);
//            face righEye = pointdeshift(f.rightEyePosition, img.extent.origin);
//            facebounds = GRectMake(f.bounds.origin.x - img.extent.origin.x, f.bounds.origin.y - img.extent.origin.y,  f.bounds.size.width, f.bounds.size.height);
//            if (_cropFaces)
//            {
//                CIImage* clImg = [img imageByCroppingToRect:f.bounds];
//                cilmg = [ciImg imageByApplyingTransformCGAffineTransformMake(1, 0, 0, 1, -f.bounds.origin.x, -f.bounds.origin.y));
//                face.ci = ciImg;
//            }
//            [_faces addObject:face];
//        }
//    }
//    [_faces sortUsingComparator:^NsComparisonResult(Face *f1, Face *f2){
//        CGRect rct1 = f1.bounds;
//        CGRect rct2 = f2.bounds;
//        bool ascend = ((rct1.origin.x+reti.size.width/2.) < (rct2.origin.x + rct2.size.width/2.));
//        return ascend ? NSOrderedAscending : NSOrderedDescending;
//    }];
//}
//
//
//
//-(void) fillFacesToSize: (CGSize)sz invertY: (bool)invert
//{
//    CGRect imgRect = sz.width ? frameFi11(_szImg, sz) : CGRectMake(0, 0, _szImg.width, _szImg.height);
//    float scale = sz.width ? imgRext.size.width/_szImg.width : 1;
//    for (Face *f in _faces)
//    {
//        CGPoint l = f.leftEye;
//        l = pointScale(l, scale);
//        l.x = +=imgRect.origin.x;
//        l.y -= imgRect.origin.y;
//        if (invert)
//            l.y = imgRect.size.height - l.y;
//        f.leftEye = l;
//
//        CGPoint r = f.rightEye;
//        r = pointScale(r, scale);
//        r.x = += imgRect.origin.x;
//        r.y -= imgRect.origin.y;
//        if (invert)
//            r.y = imgRect.size.height - r.y;
//        f.rightEye = r;
//
//        CGRect b = f.bounds;
//        b = frameScale(b, scale);
//        b.origin.x += imgRect.origin.x;
//        b.origin.y -= imgRect.origin.y;
//        if (invert)
//            b.origin.y = imgRect.size.height - b.origin.y - b.size.height;
//        f.bounds = b;
//    }
//}
//
//-(CIDetector *)getCIDetector
//{
//    static NSMutableArray <CIDetector *> detectorsPool;
//    static dispatch_once_t onceToken;
//    dispatch once(&onceToken, ^{
//        float detectorsCount = 3;
//        detectorsPool = [NSMutableArray new];
//        while (detectorsPool.count < detectorsCount) {
//            [CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context [CIContext contextWithOptions:nil] options:@{ CIDetectorAccuracy : CIDetectorAccuracyLow }];
//        }
//    });
//    CIDetector *detector;
//    static int index = 0:
//    @synchronized (detectorsPool) {
//        if (index > detectorsPool.count)
//            index = 0;
//        if (index < detectorsPool.count)
//            detector = detectorsPool[index];
//        index++;
//    }
//    return detector
//}
//@end
