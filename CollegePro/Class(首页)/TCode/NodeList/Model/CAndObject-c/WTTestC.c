//
//  WTTestC.c
//  TestProgress
//
//  Created by admin on 2020/7/5.
//  Copyright © 2020 happyness. All rights reserved.
//

#include "WTTestC.h"
#include <stdio.h>
#include <assert.h>
#include <stdlib.h>
#include <stddef.h>
#include <stdio.h>

void printfHelloWord(void)
{
    printf("hello world!");
    //这样在输入,或者做字符串中间的拷贝等等是不会报错的,最安全的一种做法
    char *str1="sdafadsf";
    char *str2=(char *)malloc(sizeof(char *));
    char *str3=(char *)malloc(sizeof(char *));
    char *str4=(char *)malloc(sizeof(char *));
    
//    strcpy(str2,str1);
    printf("please input str3 :");
    scanf("%s",str3);
    getchar();
//    strcpy(str4,str3);
    printf("str1 is %s\n",str1);
    printf("str2 is %s\n",str2);
    printf("str3 is %s\n",str3);
    printf("str4 is %s\n",str4);
    free(str2);
    free(str3);
    free(str4);
}
char shuchu(char a){
    return a;
}
PNode BuySListNode(SDataType data){
    
    return 3;
}
///初始化部分，我们只需要将链表的头结点置为NULL即可
void SListInit(SList*s) {
    assert(s);
    s->_pHead = NULL;
}
///尾插，首先我们要创建一个新节点，然后判断链表当前是否有节点，若没有，则直接让第一个节点指向新节点，若有，找到最后一个节点，让他指向新节点。
void SListPushBack(SList* s, SDataType data) {
    //找链表最后一个节点
    assert(s);
    PNode pNewNode = BuySListNode(data);
    if (s->_pHead == NULL) {//链表没有节点的情况
        s->_pHead = pNewNode;
    }
    else {
        PNode pCur = s->_pHead;
        while (pCur->_PNext) {
            pCur = pCur->_PNext;
        }
        //让最后一个节点指向新节点
        pCur->_PNext = pNewNode;
    }
}
void SListPopBack(SList* s) {
    assert(s);
    if (s->_pHead == NULL) {//链表中没有节点
        return;
    }
    else if (s->_pHead->_PNext == NULL) {//只有一个节点
        free(s->_pHead);
        s->_pHead = NULL;
    }
    else {                           //多个节点
        PNode pCur = s->_pHead;
        PNode pPre = NULL;
        while (pCur->_PNext) {
            pPre = pCur;
            pCur = pCur->_PNext;
        }
        free(pCur);
        pPre->_PNext = NULL;
    }
}
//头插
void SListPushFront(SList* s, SDataType data) {
    assert(s);
    PNode pNewNode = BuySListNode(data);
    if (s->_pHead == NULL) {//链表为空
        s->_pHead = pNewNode;
    }
    else {
        pNewNode->_PNext = s->_pHead;
        s->_pHead = pNewNode;
    }
}
//头删
void SListPopFront(SList* s) {
    assert(s);
    if (s->_pHead == NULL) {//链表为空
        return;
    }
    else if (s->_pHead->_PNext == NULL) {//只有一个节点
        free(s->_pHead);
        s->_pHead = NULL;
    }
    else {
        PNode pCur = s->_pHead;
        s->_pHead = pCur->_PNext;
        free(pCur);
    }
}
///在给定pos位置插入值为data的节点，分两步完成：首先找到pos位置的节点，然后再插入，所以要实现这一个功能需要两个函数来共同完成。
///插入
void SListInsert(PNode pos, SDataType data) {
    PNode pNewNode = NULL;
    if (pos == NULL) {
        return;
    }
    pNewNode = BuySListNode(data);
    
    pNewNode->_PNext = pos->_PNext;
    pos->_PNext = pNewNode;
}
///查找：
PNode SListFind(SList* s, SDataType data) {
    assert(s);
    PNode pCur = s->_pHead;
    while (pCur) {
        if (pCur->_data == data) {
            return pCur;
        }
        pCur = pCur->_PNext;
    }
    return NULL;
}
///删除给定pos位置的节点。
void SListErase(SList* s, PNode pos) {
    assert(s);
    if (pos == NULL || s->_pHead == NULL) {
        return;
    }
    if (pos== s->_pHead) {
        s->_pHead = pos->_PNext;
    }
    else {
        PNode pPrePos = s->_pHead;
        while (pPrePos&&pPrePos->_PNext != pos) {
            pPrePos = pPrePos->_PNext;
        }
        pPrePos->_PNext = pos->_PNext;
    }
    free(pos);
}
//删除第一个值为data的节点。要分三种情况：链表为空直接返回、要删除的节点为第一个节点、其它位置的节点。
void SListRemove(SList*s, SDataType data) {
    assert(s);
    if (s->_pHead == NULL) {
        return;
    }
    PNode pPre = NULL;
    PNode pCur = s->_pHead;
    while (pCur) {
        if (pCur->_data == data) {
            if (pCur == s->_pHead) {         //要删除的是第一个位置的节点
                s->_pHead = pCur->_PNext;
            }
            else {
                pPre->_PNext = pCur->_PNext;      //其它位置的情况，让前一个节点指向其后一个节点
            }
            free(pCur);
            return;
        }
        else {
            pPre = pCur;
            pCur = pCur->_PNext;
        }
    }
}
//其它：
int SListSize(SList* s) {            //获取链表有效节点的个数
    assert(s);
    int count = 0;
    PNode pCur = s->_pHead;
    while (pCur) {
        count++;
        pCur = pCur->_PNext;
    }
    return count;
}

int SListEmpty(SList* s) {              //检测链表是否为空
    assert(s);
    if (s->_pHead == NULL) {
        return -1;
    }
    return 0;
}

void SListClear(SList* s) {             //清空链表
    assert(s);
    if (s->_pHead == NULL) {
        return;
    }
    PNode pCur = s->_pHead;
    while (pCur->_PNext) {    //循环清空链表中的节点
        PNode Tmp = pCur->_PNext;
        free(pCur);
        pCur = Tmp;
    }
    if (pCur) {      //清空最后一个节点
        free(pCur);
        pCur = NULL;
    }
}

void SListDestroy(SList* s) {            //销毁链表
    assert(s);
    if (s->_pHead == NULL) {
        free(s->_pHead);
        return;
    }
    while (s->_pHead) {
        PNode Tmp = s->_pHead->_PNext;
        free(s->_pHead);
        s->_pHead = Tmp;
    }
}

void SListPrint(SList* s) {             //打印链表
    assert(s);
    PNode pCur = s->_pHead;
    while (pCur) {
        printf("%d--->", pCur->_data);
        pCur = pCur->_PNext;
    }
    printf("\n");
}
void mainTest() {
    SList s;
    SListInit(&s);
    SListPushBack(&s, 1);
    SListPushBack(&s, 2);
    SListPushBack(&s, 3);
    printf("size=%d\n", SListSize(&s));
    SListPrint(&s);
    SListInsert(SListFind(&s, 2), 0);
    SListPrint(&s);
    SListRemove(&s, 2);
    SListPrint(&s);
    
    return;
}
//int testHelloll (char *str){
//    return [[WTTestObject installShare] sayHello:str];
//}

