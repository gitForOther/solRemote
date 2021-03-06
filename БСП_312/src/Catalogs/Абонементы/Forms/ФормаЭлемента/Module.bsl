
&НаКлиенте
Процедура Подбор(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Ложь);
	
	ОткрытьФорму("Справочник.КабинкиЗагара.Форма.ФормаВыбора", ПараметрыФормы, ЭтаФорма,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ДействуетНаКабинкуПриИзменении(Элемент)
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимость()
	
	Элементы.Группа2.Видимость = Объект.ДействуетНаКабинкиИзФильтра;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	ПараметрыОтбора = Новый Структура("Кабинка", ВыбранноеЗначение);
	МассивНайденныхСтрок = Объект.Кабинки.НайтиСтроки(ПараметрыОтбора);  
	Если МассивНайденныхСтрок.Количество() = 0  Тогда
		НовСтр = Объект.Кабинки.Добавить();
		НовСтр.Кабинка = ВыбранноеЗначение;	
	КонецЕсли;
КонецПроцедуры





