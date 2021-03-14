from db import Session, User, ShoppingList, Item, UserResp, ShoppingListResp, ItemResp
import random
from typing import Optional, List, Tuple
from fastapi import FastAPI, File, UploadFile, Depends, HTTPException, status
from db import (
    Session,
)
from db.shopping import (
    User,
    ShoppingList,
    Item,
)
from fastapi.security import HTTPBasic, HTTPBasicCredentials

security = HTTPBasic()


import time
import config

app = FastAPI()


def get_current_username(credentials: HTTPBasicCredentials = Depends(security)):
    session = Session()
    u = session.query(User).filter(User.username == credentials.username).first()
    session.close()
    if not (u is not None and u.password == credentials.password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect email or password",
            headers={"WWW-Authenticate": "Basic"},
        )
    return credentials.username


@app.get("/login")
def read_current_user(username: str = Depends(get_current_username)):
    return {"username": username}


@app.post("/users/shoppinglists")
def read_item(
    shopping: ShoppingListResp,
    username: str = Depends(get_current_username),
):
    aList = ShoppingList(
        numItems=shopping.numItems,
        listId=shopping.listId,
        user=username,
    )
    session = Session()
    session.add(aList)
    session.commit()
    session.close()
    return


@app.post("/users/shoppinglists/{shoppingListId}/items")
def read_item(shopping: ItemResp, shoppingListId: int, username: str = Depends(get_current_username), ):
    anItem = Item(
        barcode=shopping.barcode,
        itemId=shopping.itemId,
        shoppingListId=shoppingListId,
        user=username,
        time = int(time.time())
    )
    session = Session()
    session.add(anItem)
    ls = session.query(ShoppingList).filter(ShoppingList.listId == anItem.shoppingListId).first()
    if len(ls.bought) == 1:
        ls.startTime = time.time()
    
    if len(ls.bought) == ls.numItems:
        ls.completionTime = time.time()
        ls.differenceTime = ls.completionTime - ls.startTime
    session.commit()
    session.close()
    return
@app.post("/users")
def read_item(shopping: UserResp):
    aUser = User(
        username = shopping.username,
        password = shopping.password
        
    )
    session = Session()
    session.add(aUser)
    session.commit()
    session.close()
    return

@app.get("/users/shoppinglists")
def read_list(shopListId: int, username : str = Depends(get_current_username)):
    session = Session()
    listinfo = session.query(ShoppingList).filter(ShoppingList.user == username).filter(ShoppingList.listId == shopListId).all()
    session.close()
    return listinfo

@app.get("/users/shoppinglists/{shoppingListId}/items")
def read_items(shoppingListId: int, username : str = Depends(get_current_username)):
    session = Session()
    itemInfo = session.query(Item).filter(Item.user == username).filter(Item.shoppingListId == shoppingListId).all()
    session.close()

    return itemInfo

@app.get("/leaderboard", response_model = List[Tuple[str, int]])
def leaderboard():
    session = Session()
    leaderBoardInfo = session.query(ShoppingList).all()
    listOfNames = []
    listOfTimes = []
    orderedList = []
    orderedTimes = []
    print(leaderBoardInfo)
    for x in leaderBoardInfo:
        if x.differenceTime is not None:    
            listOfNames.append((x.user, x.differenceTime,x.differenceTime /x.numItems))
        numberOfTimes = len(listOfTimes)
    orderedList = sorted(listOfNames, key = lambda x: x[2])
        
        
    session.close()
    return [[i[0],i[2]] for i in orderedList[:7]] # top 7
# session = Session()
# ans = session.query(Item).filter(Item.itemId == 33).all()
# session.close()
# for a in ans:
#    print(a.barcode, a.time)
# print(ans)

# for i in range(500, 600):
#    item = Item(barcode=i*512, time= random.randint(0,10) *10, itemId=i)
#    session = Session()
###    session.add(item)
#    session.commit()
#    session.close()

# shoppingList = ShoppingList(numItems = 2, completionTime = 5, listId = 123, user = "hello")
##user = User(username= "hello", password = "goodbye")
# item = Item(barcode =2389479, time = 12, itemId = 1, shoppingListId = 123)
# session = Session()

# session.add(user)
# session.add(shoppingList)
# session.add(item)
# session.commit()
# session.close()
