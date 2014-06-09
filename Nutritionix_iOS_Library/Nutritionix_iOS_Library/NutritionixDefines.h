
#define IS_IOS7_OR_GREATER ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define kApplicationName @"Nutritionix iOS Library"
#define kApplicationQueueName @"NILQueue"


typedef enum
{
 NILObjectRestaurant = 0,
 NILPackagedFood,
 NILCommonFoods
} NILItemType;

