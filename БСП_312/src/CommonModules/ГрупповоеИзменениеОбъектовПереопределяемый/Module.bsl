///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определить объекты метаданных, в модулях менеджеров которых ограничивается возможность 
// редактирования реквизитов при групповом изменении.
//
// Параметры:
//   Объекты - Соответствие - в качестве ключа указать полное имя объекта метаданных,
//                            подключенного к подсистеме "Групповое изменение объектов". 
//                            Дополнительно в значении могут быть перечислены имена экспортных функций:
//                            "РеквизитыНеРедактируемыеВГрупповойОбработке",
//                            "РеквизитыРедактируемыеВГрупповойОбработке".
//                            Каждое имя должно начинаться с новой строки.
//                            Если указано "*", значит, в модуле менеджера определены обе функции.
//
// Пример: 
//   Объекты.Вставить(Метаданные.Документы.ЗаказПокупателя.ПолноеИмя(), "*"); // определены обе функции.
//   Объекты.Вставить(Метаданные.БизнесПроцессы.ЗаданиеСРолевойАдресацией.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
//   Объекты.Вставить(Метаданные.Справочники.Партнеры.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке
//		|РеквизитыНеРедактируемыеВГрупповойОбработке");
//
Процедура ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти
