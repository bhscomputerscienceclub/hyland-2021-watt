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
)


class User(Base):
    __tablename__ = "Users"
    shopping_list = Column(List)
    username = Column(String, primary_key=True)
    password = Column(String)


    def dict(self):
        return {
            "shopping_list": shopping_list,
            "username": username,
            "password": password,
        }


