#ifndef SM3_SM3_H

#define SM3_SM3_H


#include <vector>

//#import <vector>
typedef uint32_t Word;

typedef uint8_t Byte;


class SM3T {
    
    private:
        
        static void CF(Word* V, Byte* B);
        
        static Word P0(Word X);
        
        static Word P1(Word X);
        
        static Word FF(int j, Word X, Word Y, Word Z);
        
        static Word GG(int j, Word X, Word Y, Word Z);
        
        static Word T(int j);
        
    public:
        
        static Word* hash(Byte* input, uint64_t inputLen);
    
};



#endif //SM3_SM3_H
