"use client";
import Logo from "@/components/Logo";
import {
  Avatar,
  Dropdown,
  DropdownItem,
  DropdownMenu,
  DropdownTrigger,
  Navbar,
  NavbarContent,
  NavbarItem,
} from "@nextui-org/react";
import { SignOut } from "@phosphor-icons/react";
import { H2 } from "../Heading";
export default function PrivateNavbar() {
  return (
    <Navbar
      isBlurred={false}
      maxWidth="full"
      className="fixed top-0 left-0 shadow-md py-1">
      <NavbarContent justify="start">
        <NavbarItem>
          <Logo className="size-12" />
        </NavbarItem>
        <NavbarItem className="flex flex-col h-full w-fit items-start justify-center">
          <H2 className="">Hệ thống quản lý trung tâm anh ngữ đa chi nhánh</H2>
        </NavbarItem>
      </NavbarContent>
      <NavbarContent className="gap-4" justify="end">
        <Dropdown radius="md">
          <DropdownTrigger>
            <Avatar src="/user.svg" isBordered color="default" />
          </DropdownTrigger>
          <DropdownMenu>
            <DropdownItem
              color="danger"
              className="text-error-500"
              startContent={<SignOut />}>
              Sign out
            </DropdownItem>
          </DropdownMenu>
        </Dropdown>
      </NavbarContent>
    </Navbar>
  );
}
