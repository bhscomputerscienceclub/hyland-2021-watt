from typing import List
from . import Base

from sqlalchemy import (
    Column,
    Integer,
    String,
    PickleType,
    DateTime,
    create_engine,
    ForeignKey,
    UniqueConstraint,
    relationship
)


class User(Base):
    __tablename__ = "Users"
    shopping_list = relationship("ShoppingList")
    username = Column(String, primary_key=True)
    password = Column(String)


    def dict(self):
        return {
            "shopping_list": self.shopping_list,
            "username": self.username,
            "password": self.password,
        }

class ShoppingList(Base):
    __tablename__ = "ShoppingList"
    numItems = Column(Integer)
    bought = relationship("Item")
    completionTime = Column(Integer)
    listId = Column(Integer, ForeignKey('Users.shopping_list'), primary_key=True)


    def dict(self):
        return {
            "numItems": self.numItems,
            "bought": self.bought,
            "completionTime": self.competionTime,
            "listId": self.listId,
        }

class Item(Base):
    __tablename__ = "item"
    barcode = Column(Integer)
    #is time needed here?
    time = Column(Integer)
    itemId = Column(Integer, ForeignKey('ShoppingList.listId'), primary_key=True)
    def __repr__(self):
        return {
            "barcode": self.barcode,
            "time": self.time,
            "itemId": self.itemId,
        }

