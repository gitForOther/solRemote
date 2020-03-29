#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Параметры.Свойство("ОткрытиеИзСписка") Тогда
		// Открытие по навигационной ссылке.
		Если РаботаСБанками.КлассификаторАктуален() Тогда
			ОповеститьКлассификаторАктуален = Истина;
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаВыборИсточника;
	
	ВыполнитьПроверкуПравДоступа("Изменение", Метаданные.Справочники.КлассификаторБанков);
	ВариантЗагрузки = "Интернет";
	
	УстановитьИзмененияВИнтерфейсе();
	
	Если ОбщегоНазначенияКлиентСервер.ЭтоМобильныйКлиент() Тогда // Временное решение для работы в мобильном клиенте, будет удалено в следующих версиях
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ВариантЗагрузки", "ВидПереключателя", ВидПереключателя.Переключатель);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаКнопкаОтмена", "Видимость", Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	УстановитьИзмененияВИнтерфейсе();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если ОповеститьКлассификаторАктуален Тогда
		РаботаСБанкамиКлиент.ОповеститьКлассификаторАктуален();
		Отказ = Истина;
		Возврат;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВариантЗагрузкиПриИзменении(Элемент)
	Путь = "";
	УстановитьИзмененияВИнтерфейсе();
КонецПроцедуры

&НаКлиенте
Процедура ПутьНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОчиститьСообщения();
	
	Если ВариантЗагрузки = "ИТС" Тогда 
		РежимДиалога = РежимДиалогаВыбораФайла.ВыборКаталога;
		ЗаголовокДиалога = НСтр("ru = 'Укажите путь к диску ИТС'");
	Иначе
		РежимДиалога = РежимДиалогаВыбораФайла.Открытие;
		ЗаголовокДиалога = НСтр("ru = 'Укажите путь к файлу классификатора'");
	КонецЕсли;
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалога);
	Диалог.Заголовок = ЗаголовокДиалога;
	Диалог.Каталог = Путь;
	Диалог.Показать(Новый ОписаниеОповещения("ПутьЗавершениеВыбора", ЭтотОбъект));
КонецПроцедуры

// Обработчик завершения выбора каталога или файла классификатора.
//  См. Синтакс-помощник: ДиалогВыбораФайла.Показать().
//
&НаКлиенте
Процедура ПутьЗавершениеВыбора(ВыбранныйПуть, ДополнительныеПараметры) Экспорт 
	Если ВыбранныйПуть = Неопределено Или ВыбранныйПуть.Количество() = 0 Тогда 
		Возврат;
	КонецЕсли;
	
	Если ВариантЗагрузки = "ИТС" Тогда 
		Путь = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ВыбранныйПуть[0]);
		ПолноеИмяФайла = Путь + "1CITS\EXE\EXTDB\bnk.zip";
	Иначе // Вариант загрузки - "Файл".
		Путь = ВыбранныйПуть[0];
		ПолноеИмяФайла = Путь;
	КонецЕсли;
	
	ФайлКлассификатора = Новый Файл(ПолноеИмяФайла);
	ФайлКлассификатора.НачатьПроверкуСуществования(
		Новый ОписаниеОповещения("ОбработатьПроверкуСуществованияКлассификатора", ЭтотОбъект));
КонецПроцедуры

// Обработчик проверки существования файла классификатора.
//  См. Синтакс-помощник: Файл.НачатьПроверкуСуществования().
//
&НаКлиенте
Процедура ОбработатьПроверкуСуществованияКлассификатора(Существует, ДополнительныеПараметры) Экспорт 
	Если Не Существует Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru ='По указанному пути файл классификатора не обнаружен.'"),, "Путь");
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Далее(Команда)
	Если Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаРезультат Тогда
		Закрыть();
		Возврат;
	КонецЕсли;
		
	ОчиститьСообщения();
	
	СообщениеОбОшибке = "";
	Если Не ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент() И Не ЗначениеЗаполнено(Путь) Тогда 
		Если ВариантЗагрузки = "ИТС" И Не ОбщегоНазначенияКлиентСервер.ЭтоWindowsКлиент() Тогда
			// Не в Windows перебор букв дисков невозможен.
			СообщениеОбОшибке = НСтр("ru = 'При работе не в ОС Windows необходимо явно указать путь к диску'");
		ИначеЕсли ВариантЗагрузки = "Файл" Тогда
			СообщениеОбОшибке = НСтр("ru = 'Укажите путь к файлу классификатора'");
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СообщениеОбОшибке) Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке,, Путь);
		Возврат;
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("НачатьЗагрузкуКлассификатора", 0.1, Истина);
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	ТекущаяСтраница = Элементы.СтраницыФормы.ТекущаяСтраница;
	
	Если ТекущаяСтраница = Элементы.СтраницаРезультат Тогда
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаВыборИсточника;
	КонецЕсли;
	
	УстановитьИзмененияВИнтерфейсе();
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Если ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ЗавершитьФоновоеЗадание(ИдентификаторЗадания);
	КонецЕсли;
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики подготовки к загрузке данных

&НаКлиенте
Процедура НачатьЗагрузкуКлассификатора()
	Если ВариантЗагрузки = "Интернет" И ТребуетсяНастройкаАвторизацияИнтернетПоддержки() Тогда
		ТекстВопроса = НСтр("ru='Для загрузки классификатора банков из Интернета
			|необходимо подключиться к Интернет-поддержке пользователей.
			|Подключиться сейчас?'");
		ОписаниеОповещения = Новый ОписаниеОповещения("ПриПодключенииИнтернетПоддержки", ЭтотОбъект);
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Подключиться'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена);
		
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Кнопки);
	Иначе
		ЗагрузитьКлассификатор();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьКлассификатор()
	// Загружает классификатор банков с диска ИТС или с сайта 1С.
	ПараметрыЗагрузки = ПараметрыЗагрузкиКлассификатора(ВариантЗагрузки);
	
	Если ВариантЗагрузки = "Интернет" Тогда
		ЗавершитьЗагрузкуКлассификатора(ПараметрыЗагрузки);
	Иначе
		НачатьПоискКлассификатора(ПараметрыЗагрузки);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьЗагрузкуКлассификатора(ПараметрыЗагрузки)
	ДлительнаяОперация = ПолучитьДанныеНаСервере(ПараметрыЗагрузки);
	
	Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.ВыполняетсяЗагрузка;
	УстановитьИзмененияВИнтерфейсе();
	
	ИдентификаторЗадания = ДлительнаяОперация.ИдентификаторЗадания;

	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриЗавершенииОперацииЗагрузки", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОписаниеОповещения, ПараметрыОжидания);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики поиска данных

&НаКлиенте
Процедура НачатьПоискКлассификатора(ПараметрыЗагрузки)
	Если ЗначениеЗаполнено(Путь) Тогда
		Если ПараметрыЗагрузки.ВариантЗагрузки = "ИТС" Тогда 
			Путь = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(Путь);
			
			ПараметрыЗагрузки.ДискИТС = Путь;
			ПараметрыЗагрузки.Путь = ПараметрыЗагрузки.ДискИТС + ПараметрыЗагрузки.ПутьНаДискеИТС;
		Иначе
			ПараметрыЗагрузки.ДискИТС = "";
			ПараметрыЗагрузки.Путь = Путь;
		КонецЕсли;
		
		ПараметрыЗагрузки.КодБуквыДиска = 999;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент() Тогда 
		ОписаниеОповещения = Новый ОписаниеОповещения("ОбработатьРезультатПомещенияКлассификатора", ЭтотОбъект, ПараметрыЗагрузки);
		НачатьПомещениеФайла(ОписаниеОповещения, , , ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент(), УникальныйИдентификатор);
	Иначе
		ПродолжитьПоискКлассификатора(ПараметрыЗагрузки);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьПоискКлассификатора(ПараметрыЗагрузки) 
	Если ПараметрыЗагрузки.ВариантЗагрузки = "ИТС"
		И Не ЗначениеЗаполнено(ПараметрыЗагрузки.ДискИТС) Тогда 
		
		ПараметрыЗагрузки.КодБуквыДиска = ПараметрыЗагрузки.КодБуквыДиска + 1;
		ПараметрыЗагрузки.ДискИТС = Символ(ПараметрыЗагрузки.КодБуквыДиска) + ":\";
		ПараметрыЗагрузки.Путь = ПараметрыЗагрузки.ДискИТС + ПараметрыЗагрузки.ПутьНаДискеИТС;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗавершитьПоискКлассификатора", ЭтотОбъект, ПараметрыЗагрузки);
	
	ФайлДанных = Новый Файл(ПараметрыЗагрузки.Путь);
	ФайлДанных.НачатьПроверкуСуществования(ОписаниеОповещения);
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьПоискКлассификатора(Найден, ПараметрыЗагрузки) Экспорт 
	Если Найден Тогда 
		Если ПараметрыЗагрузки.ВариантЗагрузки = "ИТС" Тогда 
			Путь = ПараметрыЗагрузки.ДискИТС;
		КонецЕсли;
		
		ДанныеКлассификатора = Новый ДвоичныеДанные(ПараметрыЗагрузки.Путь);
		АдресДанных = ПоместитьВоВременноеХранилище(ДанныеКлассификатора, УникальныйИдентификатор);
		ПараметрыЗагрузки.АдресДанных = АдресДанных;
		
		ЗавершитьЗагрузкуКлассификатора(ПараметрыЗагрузки);
		
	ИначеЕсли ПараметрыЗагрузки.КодБуквыДиска < 91 Тогда 
		ПараметрыЗагрузки.ДискИТС = "";
		ПродолжитьПоискКлассификатора(ПараметрыЗагрузки);
	Иначе
		ТекстСообщения = НСтр("ru ='На диске 1С:ИТС не обнаружены данные классификатора БИК РФ. 
			|Для установки требуется диск 1С:ИТС, на котором содержится
			|база ""Гарант. Налоги, бухучет, предпринимательство.""'");
		ПараметрыЗагрузки.ТекстСообщения = ТекстСообщения;
		
		Элементы.ПоясняющийТекст.Заголовок = ТекстСообщения;
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаРезультат;
		
		УстановитьИзмененияВИнтерфейсе();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьРезультатПомещенияКлассификатора(Помещен, АдресДанных, ВыбранноеИмяФайла, ПараметрыЗагрузки) Экспорт 
	Если Не Помещен Тогда 
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаРезультат;
		УстановитьИзмененияВИнтерфейсе();
		Возврат;
	КонецЕсли;
	
	Если ПараметрыЗагрузки = Неопределено Тогда 
		ПараметрыЗагрузки = ПараметрыЗагрузкиКлассификатора(ВариантЗагрузки);
	КонецЕсли;
	
	ПараметрыЗагрузки.Путь = ВыбранноеИмяФайла;
	ПараметрыЗагрузки.АдресДанных = АдресДанных;
	
	ЗавершитьЗагрузкуКлассификатора(ПараметрыЗагрузки);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики загрузки данных из интернета

&НаКлиенте
Процедура ПриПодключенииИнтернетПоддержки(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей") Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеПодключенияИнтернетПоддержки", ЭтотОбъект);
		МодульИнтернетПоддержкаПользователейКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтернетПоддержкаПользователейКлиент");
		МодульИнтернетПоддержкаПользователейКлиент.ПодключитьИнтернетПоддержкуПользователей(ОписаниеОповещения, ЭтотОбъект);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеПодключенияИнтернетПоддержки(Результат, ДополнительныеПараметры) Экспорт
	Если Не (ТипЗнч(Результат) = Тип("Структура")
		И ЗначениеЗаполнено(Результат.Логин)) Тогда
		Возврат;
	КонецЕсли;
	ЗагрузитьКлассификатор();
КонецПроцедуры

&НаСервере
Функция ТребуетсяНастройкаАвторизацияИнтернетПоддержки()
	УстановитьПривилегированныйРежим(Истина);
	ИспользоватьАльтернативныйСервер = Истина;
	УстановитьПривилегированныйРежим(Ложь);
	
	Если Не ИспользоватьАльтернативныйСервер Тогда
		Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей") Тогда
			МодульИнтернетПоддержкаПользователей = ОбщегоНазначения.ОбщийМодуль("ИнтернетПоддержкаПользователей");
			Возврат Не МодульИнтернетПоддержкаПользователей.ЗаполненыДанныеАутентификацииПользователяИнтернетПоддержки();
		КонецЕсли;
	КонецЕсли;
	Возврат Ложь;
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики загрузки данных классификатора

&НаСервере
Функция ПолучитьДанныеНаСервере(ПараметрыЗагрузки)
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		ВызватьИсключение НСтр("ru = 'Загрузка классификатора банков в разделенном режиме запрещена.'");
	КонецЕсли;
	
	Если ПараметрыЗагрузки.ВариантЗагрузки <> "Интернет" Тогда
		АдресДанных = ПараметрыЗагрузки.АдресДанных;
		ПараметрыЗагрузки.АдресДанных = Новый ХранилищеЗначения(
			ПолучитьИзВременногоХранилища(АдресДанных), Новый СжатиеДанных(9));
		УдалитьИзВременногоХранилища(АдресДанных);
	КонецЕсли;
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Загрузка классификатора банков РФ'");
	Результат = ДлительныеОперации.ВыполнитьВФоне("Обработки.ЗагрузкаКлассификатораБанков.ПолучитьДанные", ПараметрыЗагрузки, ПараметрыВыполнения);
	
	Возврат Результат;
КонецФункции

&НаКлиенте
Процедура ПриЗавершенииОперацииЗагрузки(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Ошибка" Тогда
		ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(НСтр("ru = 'Загрузка классификатора банков'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			"Ошибка", Результат.ПодробноеПредставлениеОшибки, , Истина);
			
		Элементы.ПоясняющийТекст.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Загрузка классификатора банков прервана по причине:
				|%1
				|Подробности см. в журнале регистрации.'"),
			Результат.КраткоеПредставлениеОшибки);
			
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаРезультат;
		УстановитьИзмененияВИнтерфейсе();
		Возврат;
	КонецЕсли;
	
	ЗагрузитьРезультат(Результат.АдресРезультата);
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьРезультат(АдресХранилища)
	// Отображает результат попытки загрузки классификатора банков РФ в журнале регистрации
	// и в форме загрузки.
	Если ВариантЗагрузки = "ИТС" Тогда
		Источник = НСтр("ru ='Диск ИТС'");
	ИначеЕсли ВариантЗагрузки = "Файл" Тогда
		Источник = НСтр("ru ='Файл'");
	Иначе
		Источник = НСтр("ru ='Сайт 1С'");
	КонецЕсли;
	
	ПараметрыЗагрузкиКлассификатора = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	ИмяСобытия = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru ='Загрузка классификатора банков.%1'"), Источник);
	
	Если ПараметрыЗагрузкиКлассификатора.ЗагрузкаВыполнена Тогда
		ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(ИмяСобытия,, 
			ПараметрыЗагрузкиКлассификатора.ТекстСообщения, , Истина);
		РаботаСБанкамиКлиент.ОповеститьКлассификаторУспешноОбновлен();
	Иначе
		ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(ИмяСобытия, 
			"Ошибка", ПараметрыЗагрузкиКлассификатора.ТекстСообщения, , Истина);
	КонецЕсли;
	Элементы.ПоясняющийТекст.Заголовок = ПараметрыЗагрузкиКлассификатора.ТекстСообщения;
	
	Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаРезультат;
	УстановитьИзмененияВИнтерфейсе();
	
	Если (ПараметрыЗагрузкиКлассификатора.Обновлено > 0) Или (ПараметрыЗагрузкиКлассификатора.Загружено > 0) Тогда
		ОповеститьОбИзменении(Тип("СправочникСсылка.КлассификаторБанков"));
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗавершитьФоновоеЗадание(ИдентификаторЗадания)
	ФоновоеЗадание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
	Если ФоновоеЗадание <> Неопределено Тогда
		ФоновоеЗадание.Отменить();
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Общие обработчики

&НаСервере
Процедура УстановитьИзмененияВИнтерфейсе()
	ЭтоВебКлиент = ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент();
	
	// Установка свойств поля Путь.
	Элементы.Путь.Видимость = Не ЭтоВебКлиент;
	
	// Управление вариантами загрузки.
	Варианты = Элементы.ВариантЗагрузки.СписокВыбора;
	НайденныйВариант = Варианты.НайтиПоЗначению("ИТС");
	
	Если ЭтоВебКлиент Тогда 
		Если НайденныйВариант <> Неопределено Тогда 
			Варианты.Удалить(НайденныйВариант);
		КонецЕсли;
		
		Элементы.ВариантЗагрузки.ОтображениеПодсказки = ОтображениеПодсказки.ОтображатьСнизу;
		Элементы.ВариантЗагрузки.Подсказка = НСтр("ru = 'Шаг 1: Нажмите на ""Загрузить""
			|Шаг 2: В открывшемся окне нажмите на ""Выберите файл""
			|Шаг 3: Укажите путь к файлу классификатора:
			|       - На диске ИТС - <Диск ИТС>\1CITS\EXE\EXTDB\bnk.zip
			|       - На компьютере или на сетевом диске - ...\bnk.zip
			|Шаг 4: Нажмите на ""ОК""
			|Шаг 5: Дождитесь завершения загрузки.'");
	Иначе
		Если НайденныйВариант = Неопределено Тогда 
			Варианты.Вставить(1, "ИТС", НСтр("ru = 'С диска ""Информационно-технологическое сопровождение""'"));
		КонецЕсли;
		
		Элементы.Путь.Доступность = (ВариантЗагрузки <> "Интернет");
		Элементы.Путь.ПодсказкаВвода = "";
		Элементы.ВариантЗагрузки.Подсказка = "";
		Элементы.ВариантЗагрузки.ОтображениеПодсказки = ОтображениеПодсказки.Нет;
		
		Если ВариантЗагрузки = "ИТС" Тогда 
			Элементы.Путь.ПодсказкаВвода = НСтр("ru = 'Путь к диску ИТС, например E:\'");
		ИначеЕсли ВариантЗагрузки = "Файл" Тогда 
			Элементы.Путь.ПодсказкаВвода = НСтр("ru = 'Путь к файлу классификатора, например C:\...\bnk.zip'");
		КонецЕсли;
	КонецЕсли;
	
	// Установка свойств кнопок мастера загрузки.
	Если Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаВыборИсточника
		Или Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.ЗагрузкаССайта1С Тогда
		Элементы.ФормаКнопкаНазад.Видимость = Ложь;
		Элементы.ФормаКнопкаДалее.Заголовок = НСтр("ru ='Загрузить'");
		Элементы.ФормаКнопкаОтмена.Доступность = Истина;
		Элементы.ФормаКнопкаДалее.Доступность = Истина;
	ИначеЕсли Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.ВыполняетсяЗагрузка Тогда
		Элементы.ФормаКнопкаНазад.Видимость = Ложь;
		Элементы.ФормаКнопкаДалее.Доступность = Ложь;
		Элементы.ФормаКнопкаОтмена.Доступность = Истина;
	Иначе
		Элементы.ФормаКнопкаНазад.Видимость = Истина;
		Элементы.ФормаКнопкаДалее.Заголовок = НСтр("ru ='Закрыть'");
		Элементы.ФормаКнопкаОтмена.Доступность = Ложь;
		Элементы.ФормаКнопкаДалее.Доступность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Функция ПараметрыЗагрузкиКлассификатора(Знач ВариантЗагрузки)
	ПараметрыЗагрузки = Новый Структура;
	ПараметрыЗагрузки.Вставить("Загружено", 0);
	ПараметрыЗагрузки.Вставить("Обновлено", 0);
	ПараметрыЗагрузки.Вставить("ТекстСообщения", "");
	ПараметрыЗагрузки.Вставить("ЗагрузкаВыполнена", Ложь);
	ПараметрыЗагрузки.Вставить("ВариантЗагрузки", ВариантЗагрузки);
	
	Если ВариантЗагрузки <> "Интернет" Тогда
		ПараметрыЗагрузки.Вставить("ДискИТС", "");
		ПараметрыЗагрузки.Вставить("КодБуквыДиска", 67);
		ПараметрыЗагрузки.Вставить("ПутьНаДискеИТС", "1CITS\EXE\EXTDB\bnk.zip");
		ПараметрыЗагрузки.Вставить("Путь", "");
		ПараметрыЗагрузки.Вставить("АдресДанных", "");
	КонецЕсли;
	
	Возврат ПараметрыЗагрузки;
КонецФункции

#КонецОбласти
