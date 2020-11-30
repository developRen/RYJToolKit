#if DEBUG
#define MCLog(fmt, ...) NSLog((@"%s %d " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define MCLog(fmt, ...)
#endif