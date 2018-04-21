#if defined(__has_feature) && __has_feature(objc_generics)
#  define SC_GENERIC(Ts...) <Ts>
#else
#  define SC_GENERIC(Ts...)
#endif

#ifdef SCHART_HIDE_DEPRECATIONS
#   undef DEPRECATED_ATTRIBUTE
#   undef DEPRECATED_MSG_ATTRIBUTE
#   define DEPRECATED_ATTRIBUTE
#   define DEPRECATED_MSG_ATTRIBUTE(...)
#endif


