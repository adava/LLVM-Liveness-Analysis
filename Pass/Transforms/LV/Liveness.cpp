#include "llvm/Pass.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Function.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/IR/Type.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Instruction.h"
#include <string>
#include <map>
#include <typeinfo>
#include "llvm/IR/CFG.h"
#include <list>
#include <iterator>

using namespace llvm;
using namespace std;

#define DEBUG_TYPE "Liveness"

using namespace llvm;

namespace lva{
struct Liveness : public FunctionPass {
  string func_name = "test";
  static char ID;
  Liveness() : FunctionPass(ID) {
//      UEE = new std::map<BasicBlock*, std::vector<std::string>*>;
  }

    std::map<BasicBlock*, std::vector<std::string>*> killSet;
    std::map<BasicBlock*, std::vector<std::string>*> UEE;
    std::map<BasicBlock*, std::vector<std::string>*> liveOut;
    std::list<BasicBlock*> worklist;


    std::string *getValueName(Use *it){
        std::string *op = new std::string;
        if ((*it)->hasName()){
            *op = (*it)->getName();
        }
        else {
            return NULL;
        }
        return op;
    }

    // Parse the block from top to down, Add operands not existed in the KillSet and Add destination to the kill set
    void UEVar(BasicBlock* bb){
        std::pair<BasicBlock*,std::vector<std::string>*> *temp = new std::pair<BasicBlock*,std::vector<std::string>*>;
        auto killSet = new std::vector<std::string>;
        auto tempLiveB = new std::vector<std::string>;
        auto UEE = new std::vector<std::string>;
        std::vector<std::string>::iterator killSetIt;
        std::vector<std::string>::iterator UEEIt;
        errs() << bb->getName() << ":\n";
        for (auto& inst : *bb)
        {
            errs() << "\t"  << inst << "\n";
          if(inst.getOpcode() == Instruction::Load){
            errs() << "This is Load"<<"\n";
          }
          if(inst.getOpcode() == Instruction::Store){
            errs() << "This is Store"<<"\n";
          }
          if (inst.isBinaryOp() || inst.getOpcode()==Instruction::PHI || inst.getOpcode()==Instruction::ICmp)
          {
              //errs() << "inst:\t"  << inst <<  " is binary" << "\n";
            auto* ptr = dyn_cast<User>(&inst);
            auto* op3 = dyn_cast<Value>(&inst);
            //errs() << "\t" << *ptr << "\n";
            int i = 1;
            for (auto it = ptr->op_begin(); it != ptr->op_end(); ++it) {
                auto var = getValueName(it);
                if(var!=NULL){
                    if(std::find(killSet->begin(), killSet->end(), *var) == killSet->end()) {
//                        errs() << "UEVar:\t" << *(*it) << "\n";
                        UEEIt = UEE->begin();
                        if (std::find(UEE->begin(),UEE->end(),*var)==UEE->end()){
                            UEE->insert(UEEIt, *var);
                        }
                    }
                }
                i++;
            }
            std::string *op3_str = new std::string;
            *op3_str = op3->getName();
//            errs() << "op3:\t" << *op3_str << "\n";
            killSetIt = killSet->begin();
            killSet->insert(killSetIt, *op3_str);
          }
        }

        temp->first = bb;
        temp->second = killSet;
        this->killSet.insert(*temp);
        temp->first = bb;
        temp->second = UEE;
        this->UEE.insert(*temp);
    }


    bool LiveoutBlock(BasicBlock* basic_block) {

        std::vector<std::string> *liveB;
        auto search = liveOut.find(basic_block);
        if ( search != liveOut.end()){
            liveB = search->second;
        }
        else {
            liveB = new std::vector<std::string>;
        }
        // Update the Liveout of this block based on its successors
        // Union(successors) like Liveout(successor) - Killset(successor) + UEE(successor)
       auto tempLiveB = new std::vector<std::string>;
//        errs() << "--------------\n";
        for (BasicBlock *Succ : successors(basic_block)) {
            std::vector<std::string> *lSucc;
            std::vector<std::string> *kSucc;
            std::vector<std::string> *uSucc;
            std::vector<std::string> diff;
            std::map<BasicBlock*, std::vector<std::string>*>::iterator searchS;

            searchS = killSet.find(Succ);
            if (searchS != killSet.end()){
                kSucc = searchS->second;
            }
            else {
                errs() << "!!!!! the block " << Succ <<" is not in Killset list !!!!!\n";
                return false;
            }
            searchS = UEE.find(Succ);
            if (searchS != UEE.end()){
                uSucc = searchS->second;
            }
            else {
                errs() << "!!!!! the block is "<< Succ << "not in UEE list !!!!!\n";
                return false;
            }
            searchS = liveOut.find(Succ);
            if (searchS != liveOut.end()){
                lSucc = searchS->second;
                setDiff(lSucc,kSucc,&diff);
            }

//            printVarList("kSucc",kSucc);

            auto tmp2 = new std::vector<std::string>;

//            printVarList("diff",&diff);
//            printVarList("uSucc",uSucc);

            setUnion(&diff,uSucc,tmp2);

            auto tmp3 = new std::vector<std::string>;

            setUnion(tmp2,tempLiveB,tmp3);

//            printVarList("tmp2",tmp2);
//            printVarList("tempLiveB",tempLiveB);
//            printVarList("tmp3",tmp3);

            tempLiveB = tmp3;

//            printVarList("tempLiveB after",tempLiveB);


        }
        bool changed = false;
        if (tempLiveB->size()!=liveB->size() || search==liveOut.end()){
            changed =true;
        }
        else {
            std::vector<std::string>::iterator it;
            for (it = liveB->begin();it != liveB->end();it++){

                //getValueName()
                if(std::find(tempLiveB->begin(),tempLiveB->end(),*it)==tempLiveB->end()){ //maybe using set_symmetric_difference instead
                    changed = true;
                    break;
                }
            }
        }
        if (changed){
            if(search!=liveOut.end()){
                search->second = tempLiveB;
            }
            else{
                auto temp = new std::pair<BasicBlock*,std::vector<std::string>*>;
                temp->first = basic_block;
                temp->second = tempLiveB;
                this->liveOut.insert(*temp);
            }

        }
        return changed;
    }

    void printVarList(std::string listName, std::vector<std::string> *tmp){
        errs() << listName <<":\n";
        for (auto i1=tmp->begin();i1!=tmp->end();i1++){
            errs() << " "<< *i1 << "\n";
        }
    }

    std::list<BasicBlock*>* PostOrderTraverse(BasicBlock* bb, std::list<BasicBlock*> *visited, std::list<BasicBlock*> *order) {
        visited->push_back(bb);
        for (BasicBlock *succ : successors(bb)) { // Parse the left tree and, then the right tree. Technically, it would be recursive call on every successor
            if (std::find(visited->begin(), visited->end(), succ)==visited->end()){
                visited = PostOrderTraverse(succ,visited,order);
            }
        }
        order->push_back(bb);
        return visited;
    }

    void LivenessAnalysis(BasicBlock* bb) {
        bool changed = LiveoutBlock(bb);
        if(changed){
            for (BasicBlock *pred : predecessors(bb)) {
                auto el = std::find(worklist.begin(), worklist.end(), pred);
                if(el==worklist.end()){
                    worklist.push_back(pred);
                }
            }
        }
    }

    void printBlockMap(std::map<BasicBlock*, std::vector<std::string>*> *inp){
        errs() << "---------LiveOut-begin----------\n";
        for (std::map<BasicBlock*, std::vector<std::string>*>::iterator block = inp->begin();block != inp->end();block++){
            errs() << block->first->getName() << ":\n\t";
            for(auto var = block->second->begin(); var!=block->second->end();var++){
                errs() << *var << ", ";
            }
            errs() << "\n";
        }
        errs() << "---------LiveOut-end----------\n";
    }

    bool static compareStrings(std::string str1, std::string str2){
        errs() << "str1:" << str1 << "\tstr2:" << str2 << "\tcmp:" <<std::to_string(str1.compare(str2)) << "\n";
        return str1.compare(str2)==0;
    }

    void setDiff(std::vector<std::string> *s1,std::vector<std::string> *s2,std::vector<std::string> *s3){
        for (auto it=s1->begin();it!=s1->end();it++){
            if(std::find(s2->begin(),s2->end(),*it)==s2->end()){
                s3->insert(s3->end(),*it);
            }
        }
    }

    void setUnion(std::vector<std::string> *s1,std::vector<std::string> *s2,std::vector<std::string> *s3){
        *s3 = *s1;
        for (auto it=s2->begin();it!=s2->end();it++){
            if(std::find(s1->begin(),s1->end(),*it)==s1->end()){

                s3->insert(s3->end(),*it);
            }
        }
    }

    void printTraverseOrder( std::list<BasicBlock*> *visitedBlocks,  std::list<BasicBlock*> *order){
        errs() << "visited:\n";
        for(auto itt = visitedBlocks->begin(); itt!=visitedBlocks->end();itt++){
            errs() << *itt << ", ";
        }
        errs() << "\n";

        errs() << "PO:\n";
        for(auto itt = order->begin(); itt!=order->end();itt++){
            errs() << *itt << ", ";
        }
        errs() << "\n";
    }

  bool runOnFunction(Function &F) override {
        if (F.getName().compare("main")==0){
            return false;
        }
        else{
            errs() << "-----------Function name: " << F.getName() << "-----------\n";
        }
      killSet.clear();
      UEE.clear();
      liveOut.clear();
      worklist.clear();
      // initialize UEVar and the Killset on all blocks
      for (auto& basic_block : F)
      {
          UEVar(&basic_block);
      }
      BasicBlock &basicBlock = F.getEntryBlock();
      std::list<BasicBlock*> *visited = new std::list<BasicBlock*>;
      auto visitedBlocks = PostOrderTraverse(&basicBlock,visited,&worklist);

      //printTraverseOrder(visited, &worklist);

      //worklist.push_back(&basicBlock); // initialize the worklist to the entry block, then all others will be automatically added from there
      int i = 0;
      while (!worklist.empty()) // Call Liveness on the entry block until worklist is empty
      {
          auto block = worklist.front();
          LivenessAnalysis(block);
//          printBlockMap(&liveOut);
          worklist.pop_front();
          i++;
      }
      printBlockMap(&liveOut);
      return false;
  }

}; // end of struct Liveness
}  // end of anonymous namespace

char lva::Liveness::ID = 0;
static RegisterPass<lva::Liveness> X("Liveness", "Liveness Pass",
                             false /* Only looks at CFG */,
                             false /* Analysis Pass */);