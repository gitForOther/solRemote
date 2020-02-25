///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Вызывается при получении представления объекта или ссылки в зависимости от языка,
// используемого при работе пользователя.
//
// Параметры:
//  Данные               - Структура - Содержит значения полей, из которых формируется представление.
//  Представление        - Строка - В данный параметр нужно поместить сформированное представление.
//  СтандартнаяОбработка - Булево - В данный параметр передается признак формирования стандартного представления.
//  ИмяРеквизита         - Строка - Указывает, в каком реквизите хранится представление на основном языке.
//
Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка, ИмяРеквизита = "Наименование") Экспорт
	
	#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
		
		Если МультиязычностьСервер.ЭтоОсновнойЯзык() Тогда
			Возврат;
		КонецЕсли;
		
		Если МультиязычностьПовтИсп.ОбъектНеСодержитТЧПредставления(Данные.Ссылка) Тогда
			
			СуффиксЯзыка = МультиязычностьСервер.СуффиксТекущегоЯзыка();
			Если ЗначениеЗаполнено(СуффиксЯзыка) Тогда
				СтандартнаяОбработка = Ложь;
				Представление = Данные[ИмяРеквизита + СуффиксЯзыка];
			КонецЕсли;
			
		ИначеЕсли Данные.Свойство("Ссылка") Или Данные.Ссылка <> Неопределено Тогда
			ТекстЗапроса = 
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	Представления.%2 КАК Наименование
			|ИЗ
			|	%1.Представления КАК Представления
			|ГДЕ
			|	Представления.КодЯзыка = &Язык
			|	И Представления.Ссылка = &Ссылка";
			
			ТекстЗапроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЗапроса,
			Данные.Ссылка.Метаданные().ПолноеИмя(), ИмяРеквизита);
			
			Запрос = Новый Запрос(ТекстЗапроса);
			
			Запрос.УстановитьПараметр("Ссылка", Данные.Ссылка);
			Запрос.УстановитьПараметр("Язык",   ТекущийЯзык().КодЯзыка);
			
			РезультатЗапроса = Запрос.Выполнить();
			Если Не РезультатЗапроса.Пустой() Тогда
				СтандартнаяОбработка = Ложь;
				Представление = РезультатЗапроса.Выгрузить()[0].Наименование;
			КонецЕсли;
			
		КонецЕсли;
		
	#КонецЕсли
	
КонецПроцедуры

// Вызывается для формирования состава полей, из которых формируется представление объекта или ссылки.
// Состав полей формируется с учетом текущего языка пользователя.
//
// Параметры:
//  Поля                 - Массив - Массив, содержащий имена полей, которые нужны для формирования представления объекта
//                                  или ссылки.
//  СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения стандартной (системной) обработки события.
//                                  Если в теле процедуры-обработчика установить данному параметру значение Ложь,
//                                  стандартная обработка события производиться не будет.
//  ИмяРеквизита         - Строка - Указывает, в каком реквизите хранится представление на основном языке.
//
Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка, ИмяРеквизита = "Наименование") Экспорт
	
	#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
		
		Если МультиязычностьСервер.ЭтоОсновнойЯзык() Тогда
			Возврат;
		КонецЕсли;
		
		СтандартнаяОбработка = Ложь;
		Поля.Добавить(ИмяРеквизита);
		Поля.Добавить("Ссылка");
		
		Если МультиязычностьСервер.ИспользуетсяПервыйДополнительныйЯзык() Тогда
			Поля.Добавить(ИмяРеквизита + "Язык1");
		КонецЕсли;
		
		Если МультиязычностьСервер.ИспользуетсяВторойДополнительныйЯзык() Тогда
			Поля.Добавить(ИмяРеквизита +"Язык2");
		КонецЕсли;
	
	#КонецЕсли
	
КонецПроцедуры

#КонецОбласти