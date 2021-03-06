///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ЗаполнитьФормуПоОбъекту();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Объект.Ссылка.Пустая() Тогда
		ЗаполнитьФормуПоОбъекту();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьФормуПоОбъекту()
	
	ЗаполнитьЗначенияСвойств(Объект, Параметры.ЗначенияЗаполнения);
	
КонецПроцедуры